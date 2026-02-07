Since beginner linux users are advised to keep a list of commands on file, and it even has such article in the wiki, i decided to share with you my list of frequently used command. However, i decided i want it a bit more fancy and interactive, so i made it in form of a dialog menu. Here it is, my menu.sh

You can comment or make suggestions in the manjaro forum - https://forum.manjaro.org/t/my-manjaro-cheatsheet-in-a-menu-form/145943

For the beginner users: save it as a file <code>menu.sh</code> in the <code>~/.local/bin</code> hidden Folder (create if needed) then right click and in the permissions tab in properties select allow to execute as a program.
Then you can start in the terminal with menu.sh. You can even make a launcher on the panel, just don’t forget to set it to run in terminal and append <code>-launcher</code> at the end of the command. And if some subcommand does not work, check if you have the dependency in the comment on the corresponding line. 

p.s. Using mouse to select items leads to artifacts sometimes, repeat the action and it will work or use the keyboard to select. Also, the safest "anykey" is the spacebar - do not use Enter as it will be remembered for the next command!
