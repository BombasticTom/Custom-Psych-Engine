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
                        
                        switch(optionText[3]) {
                            case 'bool':
                                optionText[4] = CoolUtil.isBoolean(optionText[4]);
                            case 'string':
                                trace(optionText[5].split(','));
                                optionText[5] = optionText[5].split(',');
                        };
                        
                        var option:Option = new Option( // overriding options
                            optionText[0], // name
                            optionText[1], // description
                            optionText[2], // save (a key in which optionText info is stored)
                            optionText[3], // optionText type
                            optionText[4], // default value (might be overwritten depending on what did you set)
                            optionText[5],
                            true // other values (if it's a string option type)
                        );

                        option.isModItem = true;
                        addOption(option);
					};
                };
            };
        };

        super();
    }
}