# PhotoApplication
Application for searching, saving and sharing photos
## **This application was based by Free API Service [Unsplash](https://unsplash.com/developers/).**
This is the most useful API for searching and processing images. First of all its free and for development there is enough attempts for full testing application and even for using by potenial users. 

### Important thing. This application using only Xcode based frameworks: UIKit and CoreData.

## **Main Objectives:**
1. Search Page. This page including possibilities of searching, sharing, opening and saving photo:
<img src="https://user-images.githubusercontent.com/70747233/197475897-4fb72160-8f08-4ed1-8434-e3c16e7a89c0.png" width="200">
2. Favourite Page. This page include open full image, open image in browser, delete or share choosed image:
<img src="https://user-images.githubusercontent.com/70747233/197476868-6f918cff-f292-44f0-8fa5-3af48a12eae1.png" width= "200">
3. Example of searching:
<img src="https://user-images.githubusercontent.com/70747233/197476275-034b79a9-6c7c-4a84-b259-c4f2250c5776.png" width="200">
4. Sharing choosed photos:
<img src="https://user-images.githubusercontent.com/70747233/197476367-345bcf0c-3d47-418d-9ffe-bda604b33c34.png" width="200">
5. Add to favorite:
<img src="https://user-images.githubusercontent.com/70747233/197476630-5ea6a2d5-5f5e-4a17-903f-779e1efc2001.png" width="200">
6. Deleting image from Favourite Page view by Alert Controller sheet:
<img src="https://user-images.githubusercontent.com/70747233/197478624-722372ef-3e54-4b7c-9729-0cddc3f7322b.png" width="200">
7. Variations of open full image in Search Page and Favourite:
<img src="https://user-images.githubusercontent.com/70747233/197479133-20ef0eed-934b-4412-9bc4-4f5739b681aa.png" width="200"> <img src="https://user-images.githubusercontent.com/70747233/197479084-1dbdd95b-94fc-4325-ab98-c5e17ba68fbc.png" width="200">

### The objectives which we are achived:
- Start using Core Data for saving, loading, editing and deleting data. Images saving in two formats: in "Data" format and in "Url String" format;
- Storyboard using only for data transfer, all visual editing made by code. For easier editing and tracking;
- Application using API REST;
- On Main Page for opening photos we using UILongPressGesture because selecting items on collection view using by collection one and more photos and sharing them;
- For saving photos we using button in Navigation Controlles and UIAlertController for saving and opening photo in browser;
- Favourite Page give possibilities to delete photos by clicking on it open in full size;
- When user using page for showing full size image from Favourite Page, he can share and open image in browser.

### **Improvements for the future:**
- Add page with visual settings;
- Use UserDefaults for saving settings;
- Add FaceID and Password enter in application(if user want);
- Add page with personal data of user like name, surname, photo of user and other informations;
- Add custom popups notifications for users like "Photo saved successfully" and etc.
