//HelpView.ts: HelpView class contains the graphical structure of the help menu.
var HelpView = (function () {
    function HelpView() {
    }
    HelpView.prototype.initHelpView = function () {
        var helpContainer = document.createElement("div");
        helpContainer.id = "helpContent";
        helpContainer.className = "helpContent";
        var videoContainer = document.createElement("iframe");
        videoContainer.id = "videoContainer";
        videoContainer.width = "854";
        videoContainer.height = "480";
        videoContainer.src = "https://www.youtube.com/embed/6pnfzL_kBD0?enablejsapi=1&version=3&playerapiid=ytplayer";
        videoContainer.frameBorder = "0";
        videoContainer.allowFullscreen = true;
        videoContainer.setAttribute("allowscriptaccess", "always");
        this.videoContainer = videoContainer;
        helpContainer.appendChild(videoContainer);
        //<iframe width="854" height= "480" src= "https://www.youtube.com/embed/6pnfzL_kBD0" frameborder= "0" allowfullscreen> </iframe>
        return helpContainer;
    };
    return HelpView;
})();
//# sourceMappingURL=HelpView.js.map