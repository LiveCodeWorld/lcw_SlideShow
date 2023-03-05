script "lib_SlideShow"
--> MetaData
-
license: GPLv3
name: lib_SlideShow
type: library
version: 0.2

/*
Here we start to collect code related to creating single HTML files for slide shows on the permanent web.
*/


--> Burns
-
command display_SlideShow someFile, pBrowserObject
   if pBrowserObject is empty then
      put view_GetTemplateObject ("View|RevealJS") into pBrowserObject
   end if
   set the url of pBrowserObject to someFile
   lcw_Notify word 1 of the params
end display_SlideShow


--> Burns
-
function burns_ConstructHTML imageURLs, animationDuration
   if animationDuration is empty then put 60 into animationDuration
   put "Burns" into pageTitle
   
   put burns_ConstructImageDiv (imageURLs) into imageDiv
   put the number of lines of imageURLs into maxFrameNum
   put burns_ConstructCSS (maxFrameNum, animationDuration) into someCSS
   put css_Minify (someCSS) into someCSS
   put scaffold_GetTemplate ("burns.html") into htmlTemplate
   
   put merge (htmlTemplate) into someHTML
   
   return someHTML
end burns_ConstructHTML

function burns_ConstructImageDiv imageURLs
   -- <div class="burns image" style="background-image: url('img/1.jpg')"></div>
   put "<div class=" &quote& "burns image"  &quote&& "style=" &quote& "background-image: url('[[imageURL]]')" &quote& "></div>" into divLine
   repeat for each line imageURL in imageURLs
      put tab & tab & merge (divLine) & CR after divLines
   end repeat
   delete char -1 of divLines
   delete char 1 to 2 of divLines
   return divLines
end burns_ConstructImageDiv

function burns_ConstructCSS maxFrameNum, animationDuration
   if maxFrameNum < 1 then return empty
   put scaffold_GetTemplate ("burns_fixed") into fixedTemplate
   put merge (fixedTemplate) into fixedTemplate -- animationDuration
   
   put scaffold_GetTemplate ("burns_keyframe") into keyframeTemplate
   put scaffold_GetTemplate ("burns_child") into childTemplate
   
   put 100/maxFrameNum into frameStep
   
   repeat with keyFrameNum = 1 to maxFrameNum
      put round ((keyFrameNum-1) * frameStep) into firstPercent
      put round (firstPercent + 3/4*frameStep) into secondPercent
      put round ((keyFrameNum) * frameStep) into thirdPercent
      
      put merge (keyframeTemplate) & CR after someCSS
      put maxFrameNum - keyFrameNum into invertedKeyFrameNum
      put merge (childTemplate) & CR & CR & CR after someCSS
   end repeat
   put word 1 to -1 of fixedTemplate after someCSS
   return someCSS
end burns_ConstructCSS


--> Image
-
function image_ConstructTag imgSource, pAltText
   put "<img src=" & quote & imgSource & quote into imageTag
   if pAltText is not empty then
      put space & "alt=" & quote & pAltText & quote after imageTag
   end if
   put space & "/>" after imageTag
   return imageTag
end image_ConstructTag

function image_ConstructDataURI someImage, someExtension
   put base64encode (someImage) into encodedImage
   replace CR with empty in encodedImage
   put html_ConstructMediaType (someExtension) into mediaType
   
   -- put merge ("data:[[mediaType]];base64,[[encodedImage]]") into dataURI
   put "data" into dataURI
   if mediaType is not empty then put ":" & mediaType after dataURI
   put ";base64," after dataURI
   put encodedImage after dataURI
   return dataURI
end image_ConstructDataURI


--> HTML
-
function html_ConstructMediaType someExtension
   /*   
   The mediatype is a MIME type string, such as 'image/jpeg' for a JPEG image file. If omitted, defaults to text/plain;charset=US-ASCII
   -- https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URIs
   */
   switch someExtension
      case "jpg"
      case "jpeg"
         return "image/jpeg" into mediaType
      case "png"
         return "image/png" into mediaType
      default
         return "text/plain;charset=US-ASCII"
   end switch
end html_ConstructMediaType

function css_Minify someCSS
   replace tab with empty in someCSS
   replace CR with empty in someCSS
   return someCSS
end css_Minify
