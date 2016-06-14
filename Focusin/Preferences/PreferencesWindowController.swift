//
//  PreferencesWindowController.swift
//  Pomodoro
//
//  Created by Alberto Quesada Aranda on 13/6/16.
//  Copyright © 2016 Alberto Quesada Aranda. All rights reserved.
//

import Cocoa

/* The delegate must implement the methods to take action for the new preferences */
protocol PreferencesDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    
    var delegate: PreferencesDelegate?
    
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var pomodoroDuration: NSTextField!
    @IBOutlet weak var breakDuration: NSTextField!
    @IBOutlet weak var targetPomodoros: NSTextField!
    @IBOutlet weak var showNotifications: NSButton!
    @IBOutlet weak var showTimeInBar: NSButton!
    
    var closedWithButton: Bool = false
    let seconds: Int = 60
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)
        
        /* Load preferred settings */
        pomodoroDuration.integerValue = defaults.integerForKey(Defaults.pomodoroKey)/seconds
        breakDuration.integerValue = defaults.integerForKey(Defaults.breakKey)/seconds
        targetPomodoros.integerValue = defaults.integerForKey(Defaults.targetKey)
        showNotifications.state = defaults.integerForKey(Defaults.showNotificationsKey)
        showTimeInBar.integerValue = defaults.integerForKey(Defaults.showTimeKey)
    }
    
    override var windowNibName : String! {
        return "PreferencesWindowController"
    }
    
    /* Save the current settings and close the window */
    @IBAction func savePreferences(sender: AnyObject) {
        closedWithButton = true
        
        defaults.setValue(pomodoroDuration.integerValue * seconds, forKey: Defaults.pomodoroKey)
        defaults.setValue(breakDuration.integerValue * seconds, forKey: Defaults.breakKey)
        defaults.setValue(targetPomodoros.integerValue, forKey: Defaults.targetKey)
        defaults.setValue(showNotifications.state, forKey: Defaults.showNotificationsKey)
        defaults.setValue(showTimeInBar.state, forKey: Defaults.showTimeKey)

        closeAndSave()
        self.window?.close()
    }
    
    /* Save changes before close the window (this is performed only in case of close with default close button) */
    func windowWillClose(notification: NSNotification) {
        if(!closedWithButton) {
            savePreferences(self)
            closeAndSave()
        }
    }
    
    /* Notify of changes to delegates */
    func closeAndSave() {
        delegate?.preferencesDidUpdate()
    }

}
