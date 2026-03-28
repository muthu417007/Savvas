import { LightningElement, api, track } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import status from '@salesforce/resourceUrl/status';

export default class StatusCenterV3 extends LightningElement { 
    @track repos;

    connectedCallback (){
        let endPoint = "https://api.statuspage.io/v1/pages/k2m6ww736hqz/components?api_key=39dcde1b-8535-4d31-b93b-c774fcfe40a4";
        fetch(endPoint, {
            method: "GET"
        })
        .then((response) => response.json()) 
        /* response.json() gives us back a promise
        we need to process the promise in .then()*/
        .then((repos) => {
            this.repos = repos;
        });
    }

    renderedCallback() {
        Promise.all([
            loadScript(this, status),
        ]);
    }

  /*
    let xhr = new XMLHttpRequest();
    xhr.open("GET", QUERY_URL);
    
    xhr.setRequestHeader("Authorization", "OAuth 39dcde1b-8535-4d31-b93b-c774fcfe40a4");
    
    xhr.onreadystatechange = function () {
       if (xhr.readyState === 4) {
          console.log(xhr.status);
          console.log(xhr.responseText);
       }};
    
    xhr.send();

    var json = JSON.parse(data);
            
    alert(json["status"]);
    alert(json.status);


    var frame = document.createElement('iframe');
    frame.src = 'https://k2m6ww736hqz.statuspage.io/embed/frame';
    frame.style.position = 'fixed';
    frame.style.border = 'none';
    frame.style.boxShadow = '0 20px 32px -8px rgba(9,20,66,0.25)';
    frame.style.zIndex = '9999';
    frame.style.transition = 'left 1s ease, bottom 1s ease, right 1s ease';

    var mobile;
    if (mobile = screen.width < 450) {
        frame.src += '?mobile=true';
        frame.style.height = '20vh';
        frame.style.width = '100vw';
        frame.style.left = '-9999px';
        frame.style.bottom = '-9999px';
        frame.style.transition = 'bottom 1s ease';
    } else {
        frame.style.height = '115px';
        frame.style.width = '320px';
        frame.style.left = 'auto';
        frame.style.right = '-9999px';
        frame.style.bottom = '60px';
    }

    document.body.appendChild(frame);

    var actions = {
        showFrame: function() {
        if (mobile) {
            frame.style.left = '0';
            frame.style.bottom = '0';
        }
        else {
            frame.style.left = 'auto';
            frame.style.right = '60px'
        }
        },
        dismissFrame: function(){
        frame.style.left = '-9999px';
        }
    }

    window.addEventListener('message', function(event){
        if (event.data.action && actions.hasOwnProperty(event.data.action)) {
        actions[event.data.action](event.data);
        }
    }, false);

    window.statusEmbedTest = actions.showFrame;
*/
}