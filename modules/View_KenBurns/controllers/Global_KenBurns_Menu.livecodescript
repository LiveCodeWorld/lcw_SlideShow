script "Global | KenBurns | Menu"
--> MetaData
-
license: GPLv3
name: Global | KenBurns | Menu
type: controller
version: 0.1


--> Working on
-
function burns_GetImageDataURIs
   put asset_ListFiles ("View|KenBurns", "img", false) into imageFiles
   repeat for each line imageFile in imageFiles
      put url ("binfile:" & imageFile) into someImage
      set the itemdelimiter to "."
      put item -1 of imageFile into someExtension
      put image_ConstructDataURI (someImage, someExtension) into dataURI
      put dataURI & CR after imageDataURIs
   end repeat
   delete char -1 of imageDataURIs
   return imageDataURIs
end burns_GetImageDataURIs


--> Menu | Props
-
getprop disabled_EncodeImage [browserView]
   return true
end disabled_EncodeImage

getprop encodeImage_Param [browserView]
   put the project_ShortHtmlFiles of browserView into shortFiles
   return shortFiles
end encodeImage_Param

getprop encodeImage_Params [browserView]
   put the project_ShortImageFiles of browserView into shortFiles
   return shortFiles
end encodeImage_Params


--> Global | KenBurns | Menu
-
on menu_ConstructHtml browserView
   put burns_GetImageDataURIs() into imageDataURIs
   put burns_ConstructHTML (imageDataURIs, 180) into someHTML
   set the htmltext of browserView to someHTML
   
   asset_SetText "View|KenBurns", "burns_data.html", someHTML
   put the result into someURL
   -- put someURL
   
   -- put the project_HtmlFile ["burns_data.html"] of browserView into localFile
   -- launch_Atom localFile
end menu_ConstructHtml

on menu_EncodeImage browserView, shortImageFile
   put the project_ImageFile [shortImageFile] of browserView into localFile
   put url ("binfile:" & localfile) into someImage
   set the itemdelimiter to "."
   put item -1 of shortImageFile into someExtension
   
   put image_ConstructDataURI (someImage, someExtension) into dataURI
    
   put "Test Image" into pAltText
   put image_ConstructTag (dataURI, pAltText) into imageTag
   -- put imageTag
   set the htmltext of browserView to imageTag
end menu_EncodeImage

on _
end _

on insert_ViewAssets
   return "Global | View | Assets | Menu"
end insert_ViewAssets

on submenu_Slideshow
   return "Global | SlideShow | Menu"
end submenu_Slideshow
