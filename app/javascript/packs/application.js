// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

require("stylesheets/application.scss")
// StimulusJS
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))


// Import and register all TailwindCSS Components
import { Toggle } from "tailwindcss-stimulus-components"
// application.register('dropdown', Dropdown)
// application.register('modal', Modal)
// application.register('tabs', Tabs)
// application.register('popover', Popover)
application.register('toggle', Toggle)
// application.register('slideover', Slideover)

import { DataBindingController } from "stimulus-data-bindings";
application.register("data-binding", DataBindingController);


$( document ).on('turbolinks:load', function() {
  var expandCollapse = document.getElementById("expand-collapse");
  if (expandCollapse) {
    expandCollapse.addEventListener("click", function(){
      if (expandCollapse.textContent === "Expand") {
        var videos = document.querySelectorAll('.video');
        for (var i = 0; i < videos.length; ++i) {
          videos[i].style.display = 'block';
        }
        expandCollapse.textContent = "Collapse"
      } else {
        var videos = document.querySelectorAll('.video');
        for (var i = 0; i < videos.length; ++i) {
          videos[i].style.display = '';
        }
        expandCollapse.textContent = "Expand"
      }
    });
  }

  function labnolIframe(div) {
    var iframe = document.createElement('iframe');
    iframe.setAttribute(
      'src',
      'https://www.youtube.com/embed/' + div.dataset.id + '?autoplay=1&rel=0'
    );
    iframe.setAttribute('frameborder', '0');
    iframe.setAttribute('allowfullscreen', '1');
    iframe.setAttribute(
      'allow',
      'accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture'
    );
    iframe.setAttribute('class', 'h-full w-full');
    div.parentNode.replaceChild(iframe, div);
  }

  function initYouTubeVideos() {
    var playerElements = document.getElementsByClassName('youtube-player');
    for (var n = 0; n < playerElements.length; n++) {
      var videoId = playerElements[n].dataset.id;

      var thumbNode = document.createElement('img');
      thumbNode.src = '//img.youtube.com/vi/ID/sddefault.jpg'.replace(
        'ID',
        videoId
      );
      thumbNode.setAttribute('class', 'h-full w-full object-cover cursor-pointer');
      // div.appendChild(thumbNode);
      thumbNode.setAttribute('data-id', videoId);
      // var playButton = document.createElement('div');
      // playButton.setAttribute('class', 'play');
      // div.appendChild(playButton);
      thumbNode.onclick = function () {
        labnolIframe(this);
      };
      playerElements[n].appendChild(thumbNode);
    }
  }

  initYouTubeVideos();
  // document.addEventListener('DOMContentLoaded', initYouTubeVideos);
})
