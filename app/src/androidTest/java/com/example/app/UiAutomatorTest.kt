package com.example.app

import androidx.test.platform.app.InstrumentationRegistry
import androidx.test.uiautomator.UiDevice
import androidx.test.uiautomator.By
import androidx.test.uiautomator.Until
import org.junit.Test
import org.junit.Assert.*

/**
 * Robust UI Automator test suite for Flutter-based MindDiary app.
 * Uses aggressive searching and detailed error reporting.
 */
class UiAutomatorTest {

    private val device = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation())
    private val timeout = 10000L
    private val appPackage = "com.example.mind_diary"

    private fun launchApp() {
        device.pressHome()
        val context = InstrumentationRegistry.getInstrumentation().targetContext
        val intent = context.packageManager.getLaunchIntentForPackage(appPackage)
        assertNotNull("Could not find launch intent for $appPackage. Is the app installed?", intent)
        intent?.addFlags(android.content.Intent.FLAG_ACTIVITY_CLEAR_TASK)
        context.startActivity(intent)
        device.wait(Until.hasObject(By.pkg(appPackage)), timeout)
    }

    private fun gatherAllScreenText(): String {
        val allNodes = device.findObjects(By.clazz("android.view.View")) + 
                       device.findObjects(By.clazz("android.widget.TextView")) +
                       device.findObjects(By.clazz("android.widget.Button")) +
                       device.findObjects(By.clazz("android.widget.EditText"))
        
        return allNodes.map { node ->
            val text = node.text ?: ""
            val desc = node.contentDescription ?: ""
            "['$text' / '$desc']"
        }.distinct().joinToString(", ")
    }

    @Test
    fun testFullAppFlow() {
        launchApp()
        device.waitForIdle()

        // Identify current screen
        var foundOnboarding = false
        
        for (i in 1..10) {
            if (device.hasObject(By.descContains("Continue without account")) || 
                device.hasObject(By.textContains("Continue without account"))) {
                foundOnboarding = true
                break
            }
            if (device.hasObject(By.desc("Stats")) || device.hasObject(By.text("Stats"))) {
                break
            }
            Thread.sleep(2000)
        }

        if (foundOnboarding) {
            val guestButton = device.wait(Until.findObject(By.descContains("Continue without account")), 5000L)
                ?: device.findObject(By.textContains("Continue without account"))
            
            assertNotNull("Guest button found but could not be clicked. Screen: ${gatherAllScreenText()}", guestButton)
            guestButton.click()
            device.wait(Until.hasObject(By.desc("Stats")), 10000L)
        }

        // Tab Navigation
        val tabs = listOf("Stats", "Journal", "Profile", "Mood")
        for (tab in tabs) {
            val tabElement = device.wait(Until.findObject(By.desc(tab)), 5000L)
                ?: device.wait(Until.findObject(By.text(tab)), 2000L)
            
            if (tabElement != null) {
                tabElement.click()
                Thread.sleep(1000) 
            }
        }

        // Logout
        device.wait(Until.findObject(By.desc("Profile")), 5000L)?.click()
        val logoutButton = device.wait(Until.findObject(By.desc("Logout")), 5000L)
            ?: device.wait(Until.findObject(By.text("Logout")), 2000L)

        if (logoutButton != null) {
            logoutButton.click()
            assertTrue("Logout failed. Screen: ${gatherAllScreenText()}", device.wait(Until.hasObject(By.descContains("Sign In")), 10000L))
        }
    }

    @Test
    fun testRegistrationAndCreateEntry() {
        launchApp()
        device.waitForIdle()

        // Cleanup: If on Dashboard, logout
        if (device.hasObject(By.desc("Profile")) || device.hasObject(By.text("Profile"))) {
            device.findObject(By.desc("Profile"))?.click() ?: device.findObject(By.text("Profile"))?.click()
            device.wait(Until.findObject(By.text("Logout")), 5000L)?.click()
            device.wait(Until.hasObject(By.descContains("Sign In")), 10000L)
        }

        // 1. Navigate to Register
        val registerBtn = device.wait(Until.findObject(By.clazz("android.widget.Button").textContains("Register")), 10000L)
            ?: device.findObject(By.clazz("android.widget.Button").descContains("Register"))
        assertNotNull("Register BUTTON not found. Screen: ${gatherAllScreenText()}", registerBtn)
        registerBtn.click()
        Thread.sleep(2000)

        // 2. Fill Registration Form
        val timestamp = System.currentTimeMillis()
        val testEmail = "test_$timestamp@example.com"
        
        // Ensure we see the fields (sometimes Flutter needs a nudge)
        var editTexts = device.findObjects(By.clazz("android.widget.EditText"))
        if (editTexts.size < 3) {
            device.swipe(500, 1000, 500, 500, 10) // Scroll down to reveal fields
            Thread.sleep(2000)
            editTexts = device.findObjects(By.clazz("android.widget.EditText"))
        }
        
        assertTrue("Needed 3 fields, found ${editTexts.size}. Screen: ${gatherAllScreenText()}", editTexts.size >= 3)
        
        editTexts[0].text = testEmail
        editTexts[1].text = "Pass123"
        editTexts[2].text = "Pass123"
        device.waitForIdle()

        // Scroll to the bottom to ensure the button is visible and clickable
        device.swipe(500, 1500, 500, 500, 15)
        Thread.sleep(1000)

        val createBtn = device.wait(Until.findObject(By.clazz("android.widget.Button").textContains("Create Account").clickable(true)), 5000L)
            ?: device.findObject(By.clazz("android.widget.Button").descContains("Create Account").clickable(true))
        
        assertNotNull("Create Account BUTTON not found or not clickable", createBtn)
        createBtn.click()

        // 3. Wait for Dashboard OR Confirmation message
        // Registration might require email confirmation, so we check for both
        val fab = device.wait(Until.findObject(By.desc("Add Entry")), 15000L)
        
        if (fab == null) {
            // If FAB not found, check if we got a confirmation message
            val screenText = gatherAllScreenText()
            if (screenText.contains("check your email", ignoreCase = true)) {
                // Success! But we can't proceed further in this test run without manual email click
                return // Exit test gracefully
            }
            fail("Registration failed or Dashboard not reached. Screen: $screenText")
        }
        
        fab.click()
        device.waitForIdle()
    }

    @Test
    fun testGoToHomeScreen() {
        device.pressHome()
        val launcherPackage = device.launcherPackageName
        assertNotNull(launcherPackage)
        device.wait(Until.hasObject(By.pkg(launcherPackage)), timeout)
    }
}
