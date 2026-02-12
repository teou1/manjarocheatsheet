Since beginner linux users are advised to keep a list of commands on file, and it even has such article in the wiki, i decided to share with you my list of frequently used command. However, i decided i want it a bit more fancy and interactive, so i made it in form of a dialog menu. Here it is, my menu.sh

<img width="1896" height="975" alt="cheat-big-blue" src="https://github.com/user-attachments/assets/6f7ae2dd-96a8-48ca-b528-f30fcd649c33" />

You can comment or make suggestions in the manjaro forum - https://forum.manjaro.org/t/my-manjaro-cheatsheet-in-a-menu-form/145943

For the beginner users: save it as a file <code>menu.sh</code> in the <code>~/.local/bin</code> hidden Folder (create if needed) then right click and in the permissions tab in properties select allow to execute as a program.
Then you can start in the terminal with menu.sh. You can even make a launcher on the panel, just don’t forget to set it to run in terminal and append <code>-launcher</code> at the end of the command. And if some subcommand does not work, check if you have the dependency in the comment on the corresponding line in the source. 

You can change the default colors, and example red-black or lightgreen-black .dialogrctheme file is optionally included, just paste in you home and rename to <code>.dialogrctheme</code>.

<img width="1902" height="981" alt="cheat-big-red" src="https://github.com/user-attachments/assets/6a787426-d632-4bf3-92fd-31931f1d3686" />

<img width="1907" height="1015" alt="cheat-green" src="https://github.com/user-attachments/assets/3b931c18-db3b-4a27-a4ea-177f686a3346" />


Hint: if you decide to use a launcher on the panel to run the menu, and you use xfce, you can do the following to start the menu maximized:
<code>xfce4-terminal --maximize --title=Cheatsheet --hide-menubar --hide-toolbar -e "/home/teo/.local/bin/menu.sh"<code/>

p.s. Using mouse to click Run button after selecting items leads to artifacts sometimes, repeat the action and it will work or use Enter to run after selecting item. Also, the safest "anykey" is the spacebar - do not use Enter or arrows as it will be remembered for the next command!
