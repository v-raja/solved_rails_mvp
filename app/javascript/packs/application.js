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
    iframe.setAttribute('class', 'h-full w-full cursor-pointer');
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
      var div = document.createElement('div');
      div.setAttribute('class', 'group')
      thumbNode.setAttribute('class', 'h-full w-full object-cover cursor-pointer');
      // div.appendChild(thumbNode);
      thumbNode.setAttribute('data-id', videoId);
      // playerElements[n].setAttribute('class', 'youtube-player');fill="#f00"
      var playButton = document.createElement('div');
      playButton.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="fill-current text-black opacity-80 group-hover:opacity-100 group-hover:text-red-yt" viewBox="0 -77 512.00213 512"><path d="m501.453125 56.09375c-5.902344-21.933594-23.195313-39.222656-45.125-45.128906-40.066406-10.964844-200.332031-10.964844-200.332031-10.964844s-160.261719 0-200.328125 10.546875c-21.507813 5.902344-39.222657 23.617187-45.125 45.546875-10.542969 40.0625-10.542969 123.148438-10.542969 123.148438s0 83.503906 10.542969 123.148437c5.90625 21.929687 23.195312 39.222656 45.128906 45.128906 40.484375 10.964844 200.328125 10.964844 200.328125 10.964844s160.261719 0 200.328125-10.546875c21.933594-5.902344 39.222656-23.195312 45.128906-45.125 10.542969-40.066406 10.542969-123.148438 10.542969-123.148438s.421875-83.507812-10.546875-123.570312zm0 0"/><path d="m204.96875 256 133.269531-76.757812-133.269531-76.757813zm0 0" fill="#fff"/></svg>`
      playButton.setAttribute('class', 'absolute w-16 inset-1/2 h-16 -m-8 cursor-pointer');
      // var playButton = document.createElement('div');
      // playButton.setAttribute('class', 'play');
      div.setAttribute('data-id', videoId);

      div.appendChild(thumbNode);
      div.appendChild(playButton);
      div.onclick = function () {
        labnolIframe(this);
      };
      playerElements[n].appendChild(div);
      // playerElements[n].appendChild(playButton);
    }
  }
  initYouTubeVideos();

  // var first_expand = true;
  var expandCollapse = document.getElementById("expand-collapse");
  if (expandCollapse) {
    expandCollapse.addEventListener("click", function(){
      if (expandCollapse.textContent === "Expand") {
        // if (first_expand) {
        //   initYouTubeVideos();
        //   first_expand = false;
        // }
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

  // document.addEventListener('DOMContentLoaded', initYouTubeVideos);
})
