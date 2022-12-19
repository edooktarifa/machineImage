
# Machine Image

Machine image can created, read, update and delete machine, this app using coredata for database.
machine image hase 2 feature. 

1.Created, save, delete and update machine

2.QR Reader

    1. Created Machine Image
       A. Created
       in the machine image screen in top view, user will find + button. when user click + button will be redirect to form machine image.
       user can created machine image with form machine image, machine image has 3 form and need to fill all form.
       the form look like image below.
       <img width="400" alt="Screen Shot 2022-11-28 at 13 20 39" src="https://user-images.githubusercontent.com/70421797/208292924-28d19212-7d30-4189-b1c5-35e43af17fce.png">
      
       submit button will enable when user fill all form, if one of the forms is empty submit button always disable untill user fill all button.

       B. Read Machine Image
       user will find all machine image already add to database in machine image tab, the view look like image below:
       <img width="400" alt="Screen Shot 2022-11-28 at 13 20 39" src="https://user-images.githubusercontent.com/70421797/208293980-60c30e9e-cc8a-4ca2-b049-8cdbc22feb9c.png">

       if user swipe list right to left, user can see update and delete button like image below.
       <img width="400" alt="Screen Shot 2022-11-28 at 13 20 39" src="https://user-images.githubusercontent.com/70421797/208293997-ccc0d6e9-d254-4cd3-a9a6-0aa49454e81e.png">

       when user click delete button will be remove the list, otherwise if user choose update button user will be redirect to update screen like image below.
       <img width="400" alt="Screen Shot 2022-11-28 at 13 20 39" src="https://user-images.githubusercontent.com/70421797/208294059-66b0f03f-c8f5-4ec1-a15f-b47153b89a96.png">

       when user click list image will show detail machine, in detail machine user can add image with max 10 image add.
       after user add image will be redirect to detail machine and show image allready add. this image can be removed and can be zoom if user click zoom and delete button.
       here is evidence for detail images:
       <img width="400" alt="https://user-images.githubusercontent.com/70421797/208294147-9ea0a766-dee8-4f45-bc99-05d0bc2119d9.png">
       <img width="400" alt="https://user-images.githubusercontent.com/70421797/208294187-def1d61f-ff15-4194-bdb4-ff3094652ede.png">
    2. QR Reader
       QR Reader can read QR number already created from machine image screen. user can generate QR number with this link
       https://www.qr-code-generator.com. here is the view for QR Reader
       <img width="400" alt="Screen Shot 2022-11-28 at 13 20 39" src="https://user-images.githubusercontent.com/70421797/208294444-96528fe6-e65c-46a8-b3fc-497d2b726364.PNG">

       if user's QR number already created with that link same with QR Number in the app, app will be open detail machine.
       if QR number is not same, the app will show error pop up.

       <img width="400" alt="Screen Shot 2022-11-28 at 13 20 39" src="https://user-images.githubusercontent.com/70421797/208294364-2a619f30-195a-4f6e-8a50-6cb365cc43e3.png">

 
## Authors

- [@edooktarifa](https://www.github.com/octokatherine)


## Technology

RxSwift, RxCocoa, Snapkit, CoreData, MVVM