YUI.add("yuidoc-meta", function(Y) {
   Y.YUIDoc = { meta: {
    "classes": [
        "AdministrationRoom",
        "Cable",
        "CablePart",
        "CableType",
        "Client",
        "Clock",
        "Country",
        "Cyberfeed",
        "DNS",
        "Database",
        "Emitter_AbandonMission",
        "Emitter_AcceptMission",
        "Emitter_CompleteMission",
        "Emitter_GetCables",
        "Emitter_GetHelpContent",
        "Emitter_GetHost",
        "Emitter_GetMission",
        "Emitter_GetNodes",
        "Emitter_GetUser",
        "Emitter_Login",
        "Emitter_Logout",
        "Emitter_Ping",
        "Emitter_ProgressMission",
        "Emitter_ReconnectLogin",
        "Emitter_ShopPurchaseHost",
        "Emitter_ShopPurchaseNetwork",
        "Emitter_Terminate",
        "Emitter_Traceroute",
        "Emitter_UpdateHelpContent",
        "Filesystem",
        "GeneralRoom",
        "Gotham.Controls.Button",
        "Gotham.Controls.Slider",
        "Gotham.Database",
        "Gotham.GameLoop",
        "Gotham.Graphics.Container",
        "Gotham.Graphics.Graphics",
        "Gotham.Graphics.Polygon",
        "Gotham.Graphics.Rectangle",
        "Gotham.Graphics.Sprite",
        "Gotham.Graphics.Text",
        "Gotham.Graphics.Texture",
        "Gotham.Graphics.Tools",
        "Gotham.Network",
        "Gotham.Pattern.MVC.Controller",
        "Gotham.Pattern.MVC.View",
        "Gotham.Preload",
        "Gotham.Renderer",
        "Gotham.Scene",
        "Gotham.Sound",
        "Gotham.Util.Ajax",
        "Gotham.Util.Compression",
        "Gotham.Util.Geocoding",
        "Gotham.Util.SearchTools",
        "Gotham.Util.Util",
        "GothamGame.Controllers.AnnounceController",
        "GothamGame.Controllers.BarController",
        "GothamGame.Controllers.GothsharkController",
        "GothamGame.Controllers.HelpController",
        "GothamGame.Controllers.IdentityController",
        "GothamGame.Controllers.MissionController",
        "GothamGame.Controllers.NodeListController",
        "GothamGame.Controllers.SettingsController",
        "GothamGame.Controllers.ShopController",
        "GothamGame.Controllers.TerminalController",
        "GothamGame.Controllers.UserController",
        "GothamGame.Controllers.WorldMapController",
        "GothamGame.GothamGame",
        "GothamGame.Mission.Mission",
        "GothamGame.Mission.Requirement",
        "GothamGame.MissionEngine.MissionEngine",
        "GothamGame.Scenes.Loading",
        "GothamGame.Scenes.Menu",
        "GothamGame.Scenes.World",
        "GothamGame.Terminal.Application.Application",
        "GothamGame.Terminal.Application.ChangeDirectory",
        "GothamGame.Terminal.Application.Clear",
        "GothamGame.Terminal.Application.Copy",
        "GothamGame.Terminal.Application.ListSegments",
        "GothamGame.Terminal.Application.Move",
        "GothamGame.Terminal.Application.Perl",
        "GothamGame.Terminal.Application.Ping",
        "GothamGame.Terminal.Application.Slowloris",
        "GothamGame.Terminal.Application.Traceroute",
        "GothamGame.Terminal.Command",
        "GothamGame.Terminal.Console",
        "GothamGame.Terminal.Filesystem",
        "GothamGame.Terminal.Terminal",
        "GothamGame.Tools.HostUtils",
        "GothamGame.View.AnnounceView",
        "GothamGame.View.BarView",
        "GothamGame.View.GothsharkView",
        "GothamGame.View.HelpView",
        "GothamGame.View.IdentityView",
        "GothamGame.View.MissionView",
        "GothamGame.View.NodeListView",
        "GothamGame.View.SettingsView",
        "GothamGame.View.ShopView",
        "GothamGame.View.TerminalView",
        "GothamGame.View.UserView",
        "GothamGame.View.WorldMapView",
        "GothamObject",
        "Help",
        "HoneyCloud",
        "Host",
        "HostRoom",
        "IPProvider",
        "IPViking",
        "Identity",
        "LocalDatabase",
        "Mission",
        "MissionRequirement",
        "MissionRoom",
        "Network",
        "Node",
        "NodeCable",
        "PingRoom",
        "SocketServer",
        "Tier",
        "TracerouteRoom",
        "TweenCS.ChainItem",
        "TweenCS.Tween",
        "User",
        "UserMission",
        "UserMissionRequirement",
        "UserRoom",
        "World",
        "WorldMapRoom"
    ],
    "modules": [
        "Backend",
        "Backend.Database",
        "Backend.Emitters",
        "Backend.LocalDatabase",
        "Backend.Networking",
        "Backend.World",
        "Framework",
        "Framework.Controls",
        "Framework.Graphics",
        "Framework.Pattern.MVC",
        "Framework.Util",
        "Frontend",
        "Frontend.Controllers",
        "Frontend.Mission",
        "Frontend.Scenes",
        "Frontend.Terminal",
        "Frontend.Terminal.Application",
        "Frontend.Tools",
        "Frontend.View",
        "TweenCS"
    ],
    "allModules": [
        {
            "displayName": "Backend",
            "name": "Backend"
        },
        {
            "displayName": "Backend.Database",
            "name": "Backend.Database",
            "description": "The database class of Gotham Backend, Wraps Sequelize"
        },
        {
            "displayName": "Backend.Emitters",
            "name": "Backend.Emitters",
            "description": "Emitter for Ping (Defined as class, but is in reality a method inside PingRoom)"
        },
        {
            "displayName": "Backend.LocalDatabase",
            "name": "Backend.LocalDatabase",
            "description": "Cable model for Local Database"
        },
        {
            "displayName": "Backend.Networking",
            "name": "Backend.Networking",
            "description": "PingRoom contains emitters for Ping Events"
        },
        {
            "displayName": "Backend.World",
            "name": "Backend.World",
            "description": "World Clock, Its a clock..."
        },
        {
            "displayName": "Framework",
            "name": "Framework",
            "description": "Gotham Game Framework\n\nContains all classes for the framework."
        },
        {
            "displayName": "Framework.Controls",
            "name": "Framework.Controls",
            "description": "Button Control. Predefined button which can be easily manipulated for custom stuff."
        },
        {
            "displayName": "Framework.Graphics",
            "name": "Framework.Graphics",
            "description": "Container is just a wrapper around Pixi Container"
        },
        {
            "displayName": "Framework.Pattern.MVC",
            "name": "Framework.Pattern.MVC",
            "description": "Baseclass for the controller"
        },
        {
            "displayName": "Framework.Util",
            "name": "Framework.Util",
            "description": "AJAX Class to retrieve and post without the use of JQUERY\nIT does only rely on the normal javascript library"
        },
        {
            "displayName": "Frontend",
            "name": "Frontend"
        },
        {
            "displayName": "Frontend.Controllers",
            "name": "Frontend.Controllers",
            "description": "AnnounceController, This controller handles the Announcement which turn up on middle of the screen. Used in Mission for example"
        },
        {
            "displayName": "Frontend.Mission",
            "name": "Frontend.Mission",
            "description": "Mission contains all of the mission data retrieved from backend. It emits on Update, Complete etc."
        },
        {
            "displayName": "Frontend.Scenes",
            "name": "Frontend.Scenes",
            "description": "The game loading scene. Happens while preloading the game files"
        },
        {
            "displayName": "Frontend.Terminal",
            "name": "Frontend.Terminal",
            "description": "Command is a terminal module which parses the input to the terminal. The command registers and identifies which command that should run."
        },
        {
            "displayName": "Frontend.Terminal.Application",
            "name": "Frontend.Terminal.Application",
            "description": "Application Base class, Takes care of command parsing and opt parsing"
        },
        {
            "displayName": "Frontend.Tools",
            "name": "Frontend.Tools",
            "description": "Tools for Host / IP validation"
        },
        {
            "displayName": "Frontend.View",
            "name": "Frontend.View",
            "description": "View for the announcement messages"
        },
        {
            "displayName": "TweenCS",
            "name": "TweenCS"
        }
    ]
} };
});