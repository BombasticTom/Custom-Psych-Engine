package options;

import sys.FileSystem;

using StringTools;

class ModOptions extends BaseOptionsMenu
{
    public function new()
    {
        title = 'Mod Options';
		rpcTitle = 'Mod Options Menu'; //for Discord Rich Presence

        var luaOptionDirs:Array<String> = Paths.getModDirectories();

        for (i in 0...luaOptionDirs.length)
        {
            var directory:String = 'mods/' + luaOptionDirs[i] + '/options';
            trace(directory);
            if (FileSystem.exists(directory)) {
                for (file in FileSystem.readDirectory(directory))
                {
                    var path = haxe.io.Path.join([directory, file]);
					if (!FileSystem.isDirectory(path) && file.endsWith('.txt')) {

						var optionText:Array<Dynamic> = CoolUtil.coolTextFile(path);
                        var optionType:String = optionText[3];
                        var options:String = optionText[5];

                        var optList:Array<String> = (optionType == 'string') ? options.split(',') : null;

                        var option:Option = new Option( // overriding options
                            optionText[0], // name
                            optionText[1], // description
                            optionText[2], // save (a key in which optionText info is stored)
                            optionType, // optionText type
                            optionText[4], // default value (might be overwritten depending on what did you set)
                            optList,
                            true // other values (if it's a string option type)
                        );
                        
                        if (optionType == 'int' || optionType == 'float' || optionType == 'percent') {
                            option.displayFormat = '%v';
                            option.minValue = optionText[5];
                            option.maxValue = optionText[6];
                            option.changeValue = optionText[7];
                            option.scrollSpeed = optionText[8];
                        };

                        addOption(option);
					};
                };
            };
        };

        super();
    }
}