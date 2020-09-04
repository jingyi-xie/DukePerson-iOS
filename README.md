#   ECE564_HW 
This is the project you will use for all four of your ECE564 homework assignments. You need to download to your computer, add your code, and then add a repo under your own ID with this name ("ECE564_HW"). It is important that you use the same project name.  Any notes, additional functions, comments you want to share with the TA and I before grading please put in this file in the correspondiing section below.  Part of the grading is anything you did above and beyond the requirements, so make sure that is included here in the README.

## HW1
Extra Features:
* Added a `NetID` property to `DukePerson`.
* The `FirstName` and `LastName` text fields are **NOT** case-sensitive and whitespaces are trimmed to facilitate `find` and `update`.
* Changed the background color and added a picture Duke University.
* After successfully finding a person, all of the text fields and segmented controls are auto-completed so that it's easier to do an `update`. 
Test this by finding a person first, then update any information. After that, do another find and you should see the updated information.
* After `add/update`, all the text fields and segmented controls are cleared to facilitate further operations.
* Check if `FirstName` and `LastName` are all entered before doing a find.
* Dismiss keyboard when click on segmentedcontrols or buttons.

## HW2
**Note1: It's possible that core data has data conflict when there are many projects with the same name. I personally used [simMagnifier](http://www.microedition.biz/simMagnifier/) to locate the source of core data and delete all the files.**

**Note2: If the virtual keyboard doesn't show up, press cmd + k**

Extra Features:
* In assignment:
    * "Team" and "Email" field
    * `UIPickerView` for gender and role
    * Picture support. Find "Jingyi Xie" to see the picture
* Addtional features of my own creation
    * Core Data as database
    * `UIStackView`
    * Implemented auto layout, defining constraints for every component
    * Dismiss the keyboard when pressed "return"
    * Parse hobbies and languages into array of string
    * Email validation in add/update. If email format is invalid, you can see an error message

## HW3
add text here

## HW4
add text here


