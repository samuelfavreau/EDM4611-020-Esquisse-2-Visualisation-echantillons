# EDM4611-020-Esquisse-2-Visualisation-echantillons #


![rendu](https://user-images.githubusercontent.com/48024730/134976042-a07bda81-0b78-4e02-9fa9-8395890bae98.png)

Cette esquisse a pour but de représenter visuellement les différentes informations de couleurs d’une image sous la forme d’une spirale suivant l’algorithme de phyllotaxie.

--

Les images pouvant être examinées se trouvent dans le répertoire **"images"** présent dans le dossier **"data"**. L’image sélectionnée est d’abord copiée dans un format de 200 x 200 pixels pour ensuite être analysé, faisant en sorte qu’une image de n’importe quel dimension ou ratio pourra être examinée et analysée. Par défaut, le programme examinera la 1re image du répertoire. Pour sélectionner une autre image, appuyez sur les flèches **gauche** et **droite** du clavier. Un petit aperçu de l’image examiné par le programme peut être vu dans le coin inférieur droit de l’esquisse.

La phyllotaxie est créée plus précisément à l’aide de 2 données principales : la luminosité moyenne de l’image et les valeurs RGB moyennes de chacune des rangées de pixels de l’image. La luminosité moyenne sert à déterminer l’angle avec lequel la phyllotaxie sera construite. Les valeurs RGB sont représentées par la couleur que prend chacun des points de la spirale. Étant donné que l’image analysée possède 200 rangées de pixels, la phyllotaxie possèdera 200 points au total, un pour chaque rangée.

La phyllotaxie est présentée à l’intérieur d’un cadre de forme circulaire sur lequel est appliquée une texture ressemblant à du bois. La couleur de l’arrière-plan du cadre aura une valeur de gris de 20, mais, si la moyenne de luminosité des couleurs de l’image est de moins de 50, sa valeur de gris sera de 230. La texture de bois quant à elle est créée à l’aide de valeurs provenant d’un **noise**. Ce noise est créée avec un niveau de détails et de contraste paramétré pour que la texture soit bien visible. Ces valeurs de noise sont ensuite appliquées à la valeur de luminosité de chaque pixel d’une couleur solide de couleur marron. Cette matrice de pixels subit ensuite des transformations **d’étirement vertical** et de **compression horizontale** afin que la texture ait plus l’apparence d’une planche de bois. Cette texture est utilisée à la fois sur le cadre, mais également sur la bordure de la plaque affichant le nom de l’œuvre.

Il est également possible de donner un nom à la phyllotaxie générée qui s’affichera sur la plaque présente au bas de l’esquisse. Il suffit de taper au clavier le nom désiré suivi de la touche **ENTRER** pour confirmer le nom. Le nom donné est ensuite réutilisé sous la forme d’une gravure apparaissant autour du cadre. Cette gravure est créée à l’aide de la valeur du **byte** de chacun des caractères du titre suivant le tableau **ASCII** faisant décaler à répétition les points de la gravure. Noter que si aucun nom n’est inscrit avant d’appuyer sur la touche **ENTRER**, aucune gravure ne sera dessinée et la plaque disparaîtra.

--

Une fois que la phyllotaxie et la gravure ont fini d’être dessinées, l’image sera ensuite automatiquement exportée au format **PNG** dans un répertoire **"export"**.

--

</br>

**Inspirations:**</br>
http://algorithmicbotany.org/papers/abop/abop-ch4.pdf</br>
https://processing.org/examples/noise2d.html</br>

**Références:**</br>
Images en provenance de Pexels.com.</br>
Artistes:</br>
          David McEachan</br>
          KoolShooters</br>
          Miriam Espacio</br>
          Maria Orlova</br>
          Tomas Ryant
          
          

