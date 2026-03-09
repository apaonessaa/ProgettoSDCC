import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:newsweb/model/auth_service.dart';
import 'package:newsweb/model/retrive_data.dart';
import 'package:newsweb/model/send_data.dart';
import 'package:newsweb/model/entity/article.dart';
import 'package:newsweb/model/entity/category.dart';
import 'package:newsweb/view/layout/custom_page.dart';
import 'package:newsweb/view/layout/util.dart';
import 'package:newsweb/view/layout/article_page/layer.dart';
import 'package:newsweb/view/form/form_utils.dart';

class ArticleUpdatePage extends StatefulWidget
{
    final String title;
    const ArticleUpdatePage({super.key, required this.title});

    @override 
    _ArticleUpdatePage createState() => _ArticleUpdatePage();
}

class _ArticleUpdatePage extends State<ArticleUpdatePage> 
{
    bool isLoading = true;
    bool hasError = false;

    List<Category> categories = [];
    bool isLoadingCategory = true;
    bool hasErrorCategory = false;

    late quill.QuillController _abstractController;
    late quill.QuillController _bodyController;

    FilePickerResult? pickedFile;
    Uint8List? imageBytes;
    String? imageFilename;
    bool hasNewImage = false;
    bool isLoadingImageUploaded = true;
    bool hasErrorImageUploaded = false;

    Category? selectedCategory;
    Set<String> selectedSubcategories = {};

    bool isSaving = false;
    bool isDeleting = false;
    bool loggedIn = false;
    bool isLoadingLogin = true;
    bool isLoadingSummary = false;
    bool isLoadingBody = false;
    bool isLoadingSelectedCategory = false;

    @override
    void initState() 
    {
        super.initState();
        _abstractController = quill.QuillController.basic(); 
        _bodyController = quill.QuillController.basic(); 
        _loadCategories();
        _loadArticle();
        checkAccess();
    }

    @override
    void dispose() 
    {
        _abstractController.dispose();
        _bodyController.dispose();
        loggedIn=false;
        super.dispose();
    }

    @override
    void didChangeDependencies() {
        super.didChangeDependencies();
        setState(() {
            loggedIn=false;
            isLoadingCategory = true;
            categories = [];
            _abstractController = quill.QuillController.basic(); 
            _bodyController = quill.QuillController.basic(); 
        });
        
        _loadCategories();
        checkAccess();
    }

    Future<void> checkAccess() async {
        setState(() {
            isLoadingLogin = true;
        });
        final result = await AuthService.sharedInstance.checkAccess();
        if (mounted) {
            setState(() {
                loggedIn = result;
            });
        }
        setState(() {
            isLoadingLogin = false;
        });
    }

    void _loadArticle() async 
    {
        setState(() {
            isLoading = true;
            hasError = false;
        });

        try {
            final result = await RetriveData.sharedInstance.getArticle(widget.title!);
            setState(() {
                if (result != null) {
                    _abstractController = FormUtils.initQuillController(result.summary);
                    _bodyController = FormUtils.initQuillController(result.content);
                    selectedCategory = categories.firstWhereOrNull((c) => c.name == result.category);
                    selectedSubcategories = result.subcategory.toSet();
                    imageFilename = result.image;
                }
            });
            final image = await RetriveData.sharedInstance.getImage(widget.title!);
            setState(() {
                if(image!=null) {
                    imageBytes = image;
                }
            });
        } catch (error) {
            setState(() {
                hasError = true;
                Util.notify(context, "Errore con il caricamento dell'articolo.", true);
            });
        }

        setState(() {
            isLoading = false;
        });
    }

    void _loadCategories() async 
    {
        setState(() {
            isLoadingCategory = true;
            hasErrorCategory = false;
        });

        try {
            final result = await RetriveData.sharedInstance.getCategories();
            if (mounted && result != null) {
                setState(() {
                    categories = result;
                });
            }
        } catch (error) {
            if (mounted) {
                setState(() {
                    hasErrorCategory = true;
                    Util.notify(context, "Errore con il caricamento delle categorie", true);
                });
            }
        }

        setState(() {
            isLoadingCategory = false;
        });
    }

    void save() async 
    {
        setState(() {
          isSaving = true;
        });

        String _summary = jsonEncode(_abstractController.document.toDelta().toJson());
        String _content = jsonEncode(_bodyController.document.toDelta().toJson());
        if (selectedCategory == null || selectedSubcategories.isEmpty) {
            setState(() {
                isSaving = false;
                Util.notify(context, "Scegli una categoria ed almeno una sotto-categoria.", true);
            });
            return;
        }

        Article art = Article(
            title: widget.title,
            summary: _summary,
            content: _content,
            category: selectedCategory!.name,
            subcategory: selectedSubcategories.toList(),
            image: imageFilename!,
        );

        try {
            await SendData.sharedInstance.update(art, hasNewImage ? imageBytes! : null, imageFilename!);
            setState(() {
                isSaving = false;
            });
            FormUtils.gotoAdminDialog(
                context, 
                "Articolo aggiornato", 
                "L'articolo è stato aggiornato ed è disponibile al pubblico.",
                [
                    TextButton(
                        onPressed: () {
                            Navigator.of(context).pop();
                            context.go('/admin'); 
                        },
                        child: Text("Ok"),
                    )
                ]
            );
        } catch (e) {
            setState(() {
                isSaving = false;
                Util.notify(context, "L'articolo non è stato aggiornato con successo.", true);
            });
        }
    }

    void delete() async 
    {
        setState(() {
            isDeleting = true;
        });

        try {
            await SendData.sharedInstance.delete(widget.title);
            setState(() {
                isSaving = false;
            });
            FormUtils.gotoAdminDialog(
                context, 
                "Articolo eliminato", 
                "L'articolo è stato eliminato con successo.",
                [
                    TextButton(
                        onPressed: () {
                            Navigator.of(context).pop();
                            context.go('/admin'); 
                        },
                        child: Text("Ok"),
                    )
                ]
            );
        } catch (e) {
            setState(() {
                isDeleting = false;
                Util.notify(context, "Errore con l'eliminazione dell'articolo.", true);
            });
        }
    }

    void chooseImage() async 
    {
        setState(() {
            isLoadingImageUploaded = true;
            hasErrorImageUploaded = false;
        });

        try {
            pickedFile = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['jpg', 'png'],
            );
            if (pickedFile != null && pickedFile!.files.isNotEmpty) {
                setState(() {
                    final file = pickedFile!.files.first;
                    imageBytes = file.bytes;
                    //imageFilename = file.name;
                    hasNewImage = true;
                    Util.notify(context, "L'immagine è stata caricata con successo!", false);
                });
            } else {
                setState(() {
                    hasErrorImageUploaded = true;
                    Util.notify(context, "Nessuna immagine caricata.", true);
                });
            }
        } catch (e) {
            setState(() {
                hasErrorImageUploaded = true;
                Util.notify(context, "Errore con il caricamento dell'immagine", true);
            });
        } finally {
            setState(() {
                isLoadingImageUploaded = false;
            });
        }
    }

        void corrector(quill.QuillController controller) async
    {
        final selection = controller.selection;
        final textToCorrect = controller.document.getPlainText(selection.start, selection.end);

        if (textToCorrect.isEmpty) {
            setState(() {
                Util.notify(context, "Seleziona il testo da correggere.", true);
            });
        } else {
            try {
                final result = await RetriveData.sharedInstance.corrector(textToCorrect);

                controller.replaceText(selection.start, selection.end - selection.start, result, null);
                
                setState(() {
                    Util.notify(context, "Il testo è stato corretto.", false);
                });
            } catch (e) {
                setState(() {
                    Util.notify(context, "Errore nella correzione del testo.", true);
                });
            }
        }
    }

    void classifier(quill.QuillController controller) async
    {
        List<String> labels = [];

        if (selectedCategory==null) {
            labels = categories.map((category) { return category.name; }).toList();
        } else {
            labels = selectedCategory!.subcategory;
        }

        final selection = controller.selection;
        final textToClassify = controller.document.getPlainText(selection.start, selection.end);

        if (textToClassify.isEmpty) {
            setState(() {
                Util.notify(context, "Seleziona il testo da classificare.", true);
            });
        } else {
            try {
                final result = await RetriveData.sharedInstance.classifier(textToClassify, labels);
                if (selectedCategory==null) {
                    selectedCategory = categories.firstWhereOrNull((c) => c.name == result[0]);
                } else {
                    selectedSubcategories = result.toSet();
                }
                
                setState(() {
                    Util.notify(context, "Classificazione del testo avvenuta con successo.", false);
                });
            } catch (e) {
                setState(() {
                    Util.notify(context, "Errore nella correzione del testo.", true);
                });
            }
        }
    }

    void summarizer() async {
        final selection = _bodyController.selection;
        final textToSummarize = _bodyController.document.getPlainText(
            selection.start, 
            selection.extentOffset
        );

        if (textToSummarize.trim().isEmpty) {
            Util.notify(context, "Seleziona il testo da sintetizzare.", true);
            return;
        }

        try {
            final result = await RetriveData.sharedInstance.summarizer(textToSummarize);
            final currentAbstractLength = _abstractController.document.length;

            _abstractController.replaceText(0, currentAbstractLength - 1, result, null);

            setState(() {
                Util.notify(context, "Sintesi generata con successo.", false);
            });
        } catch (e) {
            setState(() {
                Util.notify(context, "Errore nella generazione della sintesi.", true);
            });
        }
    }

    @override
    Widget build(BuildContext context) 
    {
        if (isLoadingLogin) {
            return Util.isLoading();
        }

        if (!loggedIn) {
            return Util.error("Errore.");
        }

        return CustomPage(
            actions: [
                Util.btn(
                    Icons.home,
                    'Home',
                    () {
                        Navigator.of(context).pop();
                        context.go('/');
                    }
                ),
            ],
            content: [
                const SizedBox(height: 40.0),
                if (isLoadingCategory || isSaving || isDeleting)
                    Util.isLoading()
                else if (hasError)
                    Util.error('Errore con l\'aggiornamento dell\'articolo.')
                else
                    ...[
                        ..._titleForm(),
                        const SizedBox(height: 30),
                        ..._abstractForm(),
                        const SizedBox(height: 30),
                        ..._bodyForm(),
                        const SizedBox(height: 30),
                        ..._buildImage(),
                        const SizedBox(height: 30),
                        ..._buildCategory(),
                        const SizedBox(height: 70),
                        ..._buildSaveAndDelete(),
                    ],
                const SizedBox(height: 100),
            ],
        );
    }

    List<Widget> _titleForm() 
    {
        return [
            const Text(
                'Titolo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
                widget.title,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
            ),
        ];
    }

    List<Widget> _abstractForm() 
    {
        return [
            const Text(
            'Sintesi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: quill.QuillSimpleToolbar(
                    controller: _abstractController,
                    config: quill.QuillSimpleToolbarConfig(
                        showFontFamily: false,
                        showFontSize: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showListNumbers: true,
                        showListBullets: true,
                        showListCheck: true,
                        showCodeBlock: true,
                        showQuote: true,
                        showIndent: true,
                        showLink: false,
                        showDirection: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        multiRowsDisplay: true,
                        customButtons: [
                            quill.QuillToolbarCustomButtonOptions(
                                icon: Icon(Icons.spellcheck, color: Colors.red[600]),
                                onPressed: () {
                                    setState(() {
                                        isLoadingSummary = true;
                                    });

                                    corrector(_abstractController);

                                    setState(() {
                                        isLoadingSummary = false;
                                    });
                                },
                                tooltip: 'Correzione del testo con AI.',
                            ),
                        ],
                    ),
                ),
            ),
            if (isLoadingSummary)
                Util.isLoading()
            else
                Container(
                    constraints: const BoxConstraints(minHeight: 100),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                        color: Colors.white,
                    ),
                    child: quill.QuillEditor.basic(
                        controller: _abstractController,
                        config: const quill.QuillEditorConfig(
                            placeholder: "Inserisci una sintesi...",
                            scrollable: true,
                            expands: false,
                            padding: EdgeInsets.zero,
                            autoFocus: false,
                        ),
                    ),
                ),
        ];
    }

    List<Widget> _bodyForm()
    {
        return [
            const Text(
                'Contenuto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: quill.QuillSimpleToolbar(
                    controller: _bodyController,
                    config: quill.QuillSimpleToolbarConfig(
                        showFontFamily: false,
                        showFontSize: false,
                        showBoldButton: true,
                        showItalicButton: true,
                        showUnderLineButton: true,
                        showStrikeThrough: true,
                        showColorButton: false,
                        showBackgroundColorButton: false,
                        showListNumbers: true,
                        showListBullets: true,
                        showListCheck: true,
                        showCodeBlock: true,
                        showQuote: true,
                        showIndent: true,
                        showLink: true,
                        showDirection: false,
                        showSearchButton: false,
                        showSubscript: false,
                        showSuperscript: false,
                        multiRowsDisplay: false,
                        customButtons: [
                            quill.QuillToolbarCustomButtonOptions(
                                icon: Icon(Icons.summarize, color: Colors.red[600]),
                                onPressed: () {
                                    setState(() {
                                        isLoadingSummary=true;
                                    });

                                    summarizer();

                                    setState(() {
                                        isLoadingSummary=false;
                                    });
                                },
                                tooltip: 'Generazione di un abstract con AI.',
                            ),
                            quill.QuillToolbarCustomButtonOptions(
                                icon: Icon(Icons.spellcheck, color: Colors.red[600]),
                                onPressed: () {
                                    setState(() {
                                        isLoadingBody = true;
                                    });

                                    corrector(_bodyController);

                                    setState(() {
                                        isLoadingBody = false;
                                    });
                                },
                                tooltip: 'Correzione del testo con AI.',
                            ),
                            quill.QuillToolbarCustomButtonOptions(
                                icon: Icon(Icons.generating_tokens, color: Colors.red[600]),
                                onPressed: () {
                                    setState(() {
                                        isLoadingSelectedCategory=true;
                                    });

                                    classifier(_bodyController);

                                    setState(() {
                                        isLoadingSelectedCategory=false;
                                    });
                                },
                                tooltip: 'Classificazione del testo con AI.',
                            ),
                        ],
                    ),
                ),
            ),
            if (isLoadingSummary)
                Util.isLoading()
            else
                Container(
                    constraints: const BoxConstraints(minHeight: 100),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                        color: Colors.white,
                    ),
                    child: quill.QuillEditor.basic(
                        controller: _bodyController,
                        config: const quill.QuillEditorConfig(
                            placeholder: "Inserisci il contenuto...",
                            scrollable: true,
                            expands: false,
                            padding: EdgeInsets.zero,
                            autoFocus: false,
                        ),
                    ),
                ),
        ];
    }

    List<Widget> _buildImage() 
    {
        return [
            const Text(
                'Immagine',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Center(
                        child: imageBytes == null
                        ? const Icon(Icons.image, size: 200, color: Colors.grey)
                        : ClipRRect(
                            child: Image.memory(
                                imageBytes!, 
                                height: 500,
                                width: 700, 
                                fit: BoxFit.cover,
                            ),
                        ),
                    ),
                ],
            ),

            const SizedBox(height: 10.0),
            Center(
                child: SizedBox(
                    width: 120,
                    height: 30,
                    child: ElevatedButton(
                        onPressed: chooseImage,
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            textStyle: const TextStyle(fontSize: 11),
                        ),
                        child: const Text('Carica immagine'),
                    ),
                ),
            ),
        ];
    }

    List<Widget> _buildCategory() 
    {
        if (isLoadingSelectedCategory)
            return [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(
                            'Classificazione dell\'articolo...',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                    ],
                ),
            ];
        return [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(
                        selectedCategory == null ? 'Seleziona una categoria' : 'Categoria selezionata:',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                        icon: Icon(
                            selectedCategory == null 
                                ? Icons.add_circle_outline_rounded 
                                : Icons.change_circle_rounded,
                            color: Colors.red,
                        ),
                        onPressed: () => FormUtils.openFilterDialogCategory(
                            context, 
                            'Seleziona una categoria per l\'articolo.',
                            categories.map((category) {
                                final isSelected = selectedCategory?.name == category.name;
                                return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FilterChip(
                                        label: Text(category.name),
                                        selected: isSelected,
                                        selectedColor: Colors.red,
                                        checkmarkColor: Colors.black,
                                        onSelected: (selected) {
                                            setState(() {
                                                selectedCategory = category;
                                                selectedSubcategories = {}; 
                                            });
                                            Navigator.pop(context);
                                        },
                                ));
                                }).toList()
                        )                    
                    )
                ],
            ),
            if (selectedCategory != null) ...[
                Center(
                    child: Text(
                        selectedCategory!.name,
                        style: const TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.w500),
                    ),
                ),
                const SizedBox(height: 20.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Text(
                            'Sotto-categorie selezionate:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.red),
                            onPressed: () => FormUtils.openFilterDialogSubcategories(
                                context, 
                                'Sotto-categorie di ${selectedCategory!.name}',
                                selectedCategory!.subcategory.map((subcat) {
                                    final isSelected = selectedSubcategories.contains(subcat);
                                    return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FilterChip(
                                            label: Text(subcat, style: TextStyle(color: isSelected ? Colors.white : Colors.black, backgroundColor: isSelected ? Colors.red : Colors.white)),
                                            selected: isSelected,
                                            selectedColor: Colors.red,
                                            onSelected: (selected) {
                                                setState(() {
                                                    if (selected) {
                                                        selectedSubcategories.add(subcat);
                                                    } else {
                                                        selectedSubcategories.remove(subcat);
                                                    }
                                                });
                                            },
                                        ));
                                }).toList(),
                            ),
                        )
                    ],
                ),
            ],

            const SizedBox(height: 10.0),

            if (selectedSubcategories.isNotEmpty)
                Center(
                    child: Wrap(
                        spacing: 8.0, 
                        runSpacing: 4.0, 
                        children: selectedSubcategories.map((sub) {
                            return Chip(
                                label: Text(sub),
                                backgroundColor: Colors.red.withOpacity(0.1),
                                deleteIcon: const Icon(Icons.close, size: 18, color: Colors.red),
                                onDeleted: () {
                                    setState(() {
                                        selectedSubcategories.remove(sub);
                                    });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Colors.red),
                                ),
                            );
                        }).toList(),
                    ),
                ),
        ];
    }


    List<Widget> _buildSaveAndDelete() 
    {
        return [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    SizedBox(
                        width: 120,
                        height: 35,
                        child: ElevatedButton(
                            onPressed: save,
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Salva'),
                        ),
                    ),
                    const SizedBox(width: 30),
                    SizedBox(
                        width: 120,
                        height: 35,
                        child: ElevatedButton(
                            onPressed: delete,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            child: const Text('Elimina'),
                        ),
                    ),
                ],
            ),
        ];
    }
}

