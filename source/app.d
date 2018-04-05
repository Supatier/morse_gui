import gtk.Builder;
import gtk.Main;
import gtk.Widget;
import gtk.Window;
import gtk.Button;
import gtk.Entry;
import gtk.TextView;

import libmorse;

import std.algorithm : map;
import std.array : array, join;
import std.conv : text;
import std.getopt : getopt;
import std.stdio : writeln;
import std.string : toUpper;

Window w;
Entry e, t;
int main(string[] args) {
        Main.init(args);
        Builder b = new Builder();
        b.addFromString(import("asd.glade"));
        w = cast(Window) b.getObject("window");
        e = cast(Entry) b.getObject("text_entry");
        t = cast(Entry) b.getObject("text_display");
        b.connectSignals(null);
        w.addOnHide(delegate void(Widget aux) { Main.quit(); });
        w.showAll();
        Main.run();
        return 0;
}

extern (C) void onExitButtonClicked() {
        Main.quit();
}

extern (C) void onTextEntryChanged() {
        string ret;
        string[] next = toUpper(e.getText()).map!text.array;
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
        t.setText(ret);
}
