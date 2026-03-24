# Progetto SDCC

Sistema per la visualizzazione e creazioni di articoli. Ad ogni articolo viene associato un immagine, una categoria e almeno una sottocategoria. 

## Architettura e componenti

Il progetto è stato sviluppato seguendo il paradigma della progettazione a microservizi con i container Docker.

<p align="center">
<img width="482" height="299" alt="Architettura" src="https://github.com/user-attachments/assets/161fc651-6b91-4e45-9dbf-9dbed13d3d0c" />
</p>

## Deployment

Per il deployment del sistema:

```bash
$ docker compose --env-file .env up
```

Il file **.env** contiene le variabili d'ambiente utilizzate per la costruzione delle immagini dei container Docker dei servizi.

Le variabili d'ambiente da specificare nel file:

- DB_ROOT_PASSWD="***"
- DB_SPRING_USER="spring"
- DB_SPRING_PASSWD="***"
- COOKIE_SECRET="***" 32 Byte

Per l'elaborazione del testo si usano API Hugging Face i cui parametri di accesso sono specificati con le seguenti variabili d'ambiente:

- CLASSIFIER_API="***"
- CLASSIFIER_TOKEN="hf_***"
- CORRECTOR_API="***"
- CORRECTOR_MODEL="***"
- CORRECTOR_TOKEN="hf_***"
- SUMMARIZER_API="***"
- SUMMARIZER_MODEL="***"
- SUMMARIZER_TOKEN="hf_***"

## Demo

<p align="center">
<img width="463" height="510" alt="image" src="https://github.com/user-attachments/assets/a11cde8e-ebff-4d4e-a1e9-a439a92174ed" />
</p>
<p align="center">
<img width="464" height="101" alt="image" src="https://github.com/user-attachments/assets/afd12de0-2812-4ac9-88e4-b1840c511723" />
</p>

Visualizzazione di un articolo:

<p align="center">
<img width="482" height="535" alt="image" src="https://github.com/user-attachments/assets/0716d31e-16ef-4def-a5c9-ffedbba3508d" />
</p>

Accesso al pannello di amministrazione:

<p align="center">
<img width="458" height="389" alt="image" src="https://github.com/user-attachments/assets/39176df4-a3d3-4e2d-9c75-a3e0d6959a82" />
</p>
<p align="center">
<img width="482" height="429" alt="image" src="https://github.com/user-attachments/assets/1c990f68-69d8-4e1b-8583-c3cee763176c" />
</p>

Pagina per la creazione di un articolo:

<p align="center">
<img width="487" height="559" alt="image" src="https://github.com/user-attachments/assets/a935b0df-9db8-4f15-bf66-22d66f7b926b" />
</p>
<p align="center">
<img width="504" height="387" alt="image" src="https://github.com/user-attachments/assets/74a235c1-c7fc-4536-b3ca-34f65a058775" />
</p>

