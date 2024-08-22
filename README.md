# AccessFlow App

This is a System Access Control for PT Petrokimia Gresik.

![iPhone 13 Pro (14)](https://github.com/user-attachments/assets/b726b4c3-be3f-4319-a9fe-70cefbf3a0e8)
![iPhone 13 Pro (13)](https://github.com/user-attachments/assets/9e702a12-0437-47d1-ad4a-f76e7add1dec)



## Getting Started

1. This App has main feature of:

    ```CREATE ACCESS CARD
    It will create an access card like akses perumdin, id card, and access card. Here is the flow of creating access card.
    1. Splashscreen -> Onboarding -> Login -> Home -> create card page 
    There is two choice now, you can save as Draft or Submit it
    1.2 Save as Draft -> Draft Page
    1.3 Save as History -> History Page
    ```

2. This App has additional feature of:

    ```CARD TYPE INFORMATION
    available on home page
    ```
    ```APP USER GUIDE
    available on home page
    ```
    ```GENERAL INFORMATION (FAQ, Call Center, Terms of Service, etc.)
    available on profile page
    ```        

3. This File is using clean architecture so the file is :

    ```STRCTURED FROM FUNCTION FIRST TO LAYER
    example : 
    - auth
     - data
     - domain
     - presentation
    - card
     - data
     - domain
     - presentation
    ```

4. Run the app:

    ```BASH
    flutter run
    ```

## About database

- Using PostgreSQL and pgAdmin 4 as Database Management System
- Using PHP as Back-End
- Using Ngrok as Tunneling Domain between local Database and Application

## What is Needed

- Change the current local database with PT Petrokimia Gresik Database Center

## Unfinished Feature

- Uploading Image and showing image
  1. available on create_card to upload and show image
  2. available on draft to show drafted image
  3. available on history to show the uploaded image

- Notification when there is card status change ('information' page and folder is actually a notification)
  1. give notification when there is data change in history page so it give notification to user about card status.

- Dual Language(optional) ('l10n' file)
  1. Right now its using dart file to keep the strings, but it can be replaced with json string to be able to use dual language

## License

This project is licensed under the [MIT License](LICENSE).
