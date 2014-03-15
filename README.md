Laravel 4 Commander
===================

This is a batch script to help with laravel command line work on windows. 
Through the use of program launchers such a [Launchy](http://www.launchy.net/) and in combination with [Laravel-4-Generators](https://github.com/JeffreyWay/Laravel-4-Generators) by [Jeffrey Way](https://twitter.com/jeffrey_way) shortcuts can be used to simplify a lot of common tasks.

Credit goes to [Ashley Clarke](https://github.com/clarkeash) who wrote the [Laravel-Alfred-Extension](https://github.com/clarkeash/Laravel-Alfred-Extension) which inspired the creation of a windows version.

This is my second foray into batch programming so please excuse any sloppy coding :)

###Requirements

[Composer](http://getcomposer.org/download/) : As required by Laravel4.


###Installation
Download and place folder in a suitable location.
If needed add folder/files to your program launchers catalog.
You can then run commands by using

```laravel4 [command] [options]```

###Setup
On first use you will need to set a few configuration options

```laravel4 setup```
######Composer
This will ask you for your composer runtime command, default is php C:\ProgramData\Composer\bin\composer.phar which would be correct if using the composer windows installer.<br>
If you have added composer to your windows path then you can enter composer.
######Project Base
You will be asked to set the main directory where all projects will be created
***
Individual settings can be modified at any time using

```laravel4 setup composer```

```laravel4 setup base```


###Project
A new project can be created by using

```laravel4 install [folder_name]```  ie: ```laravel4 install l4```

This will then Download the latest version of Laravel within the chosen folder and set this new installation as the working project.

From here any commands run will be executed on this working project.
At any time you can change the working project by running

```laravel4 project [folder_name]``` or use the shortcut ```laravel4 p [folder_name]```
###General Commands
```laravel4 info``` This will show all your current settings including the working project.<br>
```laravel4 help``` This will bring up the help screen.<br>
```laravel4 artisan [command]``` Run any artisan command on the working project.<br>
```laravel4 composer [command]``` Run any composer command on the working project.<br>
```laravel4 composer d``` Runs composer dump-autoload -o
***
As we are focused on the [Laravel-4-Generators](https://github.com/JeffreyWay/Laravel-4-Generators) you will need to acquaint yourself with its command structure to get the best out of the following available commands.
###Commands
```laravel4 controller [controllername] [options]``` or ```laravel4 c [controllername] [options]```<br>
```laravel4 model [modelname]``` or ```laravel4 m [modelname]```<br>
```laravel4 view [viewname] [--path]``` or ```laravel4 v [viewname] [--path]```<br>
```laravel4 migration [command] [--fields]``` or ```laravel4 mig [command] [--fields]```<br>
```laravel4 migrate```<br>
```laravel4 rollback```<br>
```laravel4 seed [name]```<br>
```laravel4 resource [name] [--fields]``` or ```laravel4 r [name] [--fields]```<br>
```laravel4 scaffold [name] [--fields]``` or ```laravel4 s [name] [--fields]```<br>
 
###Examples
Create a model<br>
```laravel4 m Post```

migration<br>
```laravel4 mig create_posts_table --fields="title:string, body:text"```

Resource<br>
```laravel4 r dog --fields="name:string"```
***
##Launchy
To help you get this setup in [Launchy](http://www.launchy.net/) hit ALT+SPACE to bring up its window and click on the options icon (top right). On the Catalog tab you will need to add the laravel commander folder to the Directories and \*.\* to the File Types area. Once done hit Rescan Catalog and ok out.

![Launchy Options](https://dl.dropboxusercontent.com/s/hjelyeg8jaaiibz/launchy1ss.png "Launchy Options")

From here on all commands can be accessed like the following<br>
ALT+SPACE type laravel4 [TAB] install l4

![Launchy Run Command](https://dl.dropboxusercontent.com/s/2gedudufdeikf75/launchy2ss.png "Launchy Run Command")