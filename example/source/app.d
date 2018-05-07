import std.algorithm : map;
import std.array : array, join;
import std.conv : text;
import std.getopt : getopt;
import std.stdio : writeln;
import std.string : toUpper;
import std.functional : toDelegate;

import stdlib = core.stdc.stdlib : exit;

import gtk.Window;
import gtk.Entry;
import gtk.Button;
import gtk.Main;
import gtk.Label;
import gdk.Event;
import gtk.Widget;

import gio.Application : GioApplication = Application;
import gtk.Application;
import gtk.ApplicationWindow;

import gtk.Box;
import gtk.EditableIF;
import gtk.ButtonBox;
import glib.MainLoop;

import libmorse;

public class MainWindow : ApplicationWindow {
        private Box box;
        private Button exitButton;
        private Label lable;
        private Entry textEntry, textDisplay;
        private ButtonBox buttonBox;

        this(Application application) {
                super(application);
                setDefaultSize(400, 200);
                setBorderWidth(6);
                setTitle("Morse Code Viewer");

                box = new Box(Orientation.VERTICAL, 5);
                this.add(box);

                lable = new Label("Insert Text", true);
                lable.setMarginTop(10);
                lable.setMarginBottom(10);
                box.packStart(lable, false, true, 1);

                textEntry = new Entry();
                textEntry.setMarginBottom(10);
                textEntry.setPlaceholderText("Insert text here");
                textEntry.addOnChanged(&onTextChanged);
                box.packStart(textEntry, false, true, 2);

                textDisplay = new Entry();
                textDisplay.setMarginTop(10);
                textDisplay.setMarginBottom(10);
                textDisplay.setCanFocus(false);
                textDisplay.setEditable(false);
                box.packStart(textDisplay, false, true, 3);

                buttonBox = new ButtonBox(Orientation.HORIZONTAL);
                buttonBox.setLayout(ButtonBoxStyle.END);

                exitButton = new Button();
                exitButton.setLabel("Exit");
                exitButton.addOnButtonPress(&onExitButtonPressed);
                buttonBox.packStart(exitButton, true, true, 1);

                box.packStart(buttonBox, false, false, 5);
                showAll();
        }

        private void onTextChanged(EditableIF input) {
                string ret;
                string[] next = toUpper(textEntry.getText()).map!text.array;
                foreach (i, e; next) {
                        if (e in morseCode) {
                                ret ~= morseCode[e];
                        } else {
                                writeln("Symbol :", e, " has no morsecode.");
                        }
                        ret ~= " ";
                }

                if (ret == null) {
                        ret = " ";
                }
                textDisplay.setText(ret);
        }

        private bool onExitButtonPressed(Event event, Widget widget) {
                stdlib.exit(0);
                return true;
        }
}

int main(string[] args) {
        auto application = new Application("org.supatier.morsedisplay",
                        GApplicationFlags.FLAGS_NONE);
        application.addOnActivate(delegate void(GioApplication app) {
                new MainWindow(application);
        });
        return application.run(args);
}
