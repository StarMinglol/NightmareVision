
package funkin.utils;

import sys.io.File;
import haxe.io.Bytes;
import sys.io.Process;

@:cppFileCode('
#include <stdlib.h>
#include <stdio.h>
#include <windows.h>
#include <winuser.h>
#include <dwmapi.h>
#include <strsafe.h>
#include <shellapi.h>
#include <iostream>
#include <string>

#pragma comment(lib, "Dwmapi")
#pragma comment(lib, "Shell32.lib")
')

class SystemUtil
{
	static public function windowsTransparent(e:Bool) //easy tool
	{
		if(e){
			getWindowsTransparent();
		}else{
			getWindowsbackward();
		}
	}

	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(0, 1, 1), 0, LWA_COLORKEY);
        }
	')
	static public function getWindowsTransparent(res:Int = 0) 
	{
		return res;
	}

	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(255, 5, 55), 1, LWA_COLORKEY);
        }
    ')
	static public function getWindowsbackward(res:Int = 0)
	{
		return res;
	}

	@:functionCode('
        LPCSTR lwDesc = desc.c_str();

        res = MessageBox(
            NULL,
            lwDesc,
            NULL,
            MB_OK
        );
    ')
	static public function sendFakeMsgBox(desc:String = "", res:Int = 0) // TODO: Linux and macOS (will do soon)
	{
		return res;
	}

	static public function sendNotification(title:String, message:String, time:Float = 5)
	{
		var powershellCmd:String = 
			"[reflection.assembly]::LoadWithPartialName('System.Windows.Forms'); " +
			"$obj = New-Object System.Windows.Forms.NotifyIcon; " +
			"$obj.Icon = [System.Drawing.SystemIcons]::Information; " +
			"$obj.BalloonTipTitle = '" + title + "'; " +
			"$obj.BalloonTipText = '" + message + "'; " +
			"$obj.Visible = $True; " +
			"$obj.ShowBalloonTip(" + time*1000 + ");"
		;

		try {
			new Process("powershell", ["-WindowStyle", "Hidden", "-Command", powershellCmd]);
		} catch (e:Dynamic) {
			trace(e);
		}		
	}

	public static function generateTextFile(fileContent:String, fileName:String)
	{
		var path = SystemUtil.getTempPath() + "/" + fileName + ".txt";

		File.saveContent(path, fileContent);
		Sys.command("start " + path);
	}


	//Some function for info

	public static function getUsername():String
	{
		return Sys.getEnv("USERNAME");
	}

	public static function getUserPath():String
	{
		return Sys.getEnv("USERPROFILE");
	}

	public static function getGamePath():String
	{
		return Sys.getCwd();
	}

	public static function getTempPath():String
	{
		return Sys.getEnv("TEMP");
	}

}
