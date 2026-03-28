$(function () {

	//tooltips
	$('#knowledgeSearch').tooltip();
	$('#schoolCode').tooltip();

	$(".emailBox").click(function(){
		window.location = $(this).attr("data-href");
		return false;
	});

});

function createMenu(menu) {
    var ul = document.createElement('ul');
    ul.className = 'nav navbar-nav';
    for (var i = 0; i < menu.items.length; i++) {
        createItem(ul, menu.items[i]);
    }
    var m2 = document.getElementById('menu2');
    m2.appendChild(ul);
    /**
      * NAME: Bootstrap 3 Triple Nested Sub-Menus
      * This script will active Triple level multi drop-down menus in Bootstrap 3.*
      */
    $('#menu2 ul.dropdown-menu [data-toggle=dropdown]').on('click', function(event) {
        // Avoid following the href location when clicking
        event.preventDefault();
        // Avoid having the menu to close when clicking
        event.stopPropagation();
        if ($(this).parent().hasClass('open')) {
            $(this).parent().removeClass('open');
        } else {
            $(this).parents('.dropdown-menu:first').find('li').removeClass('open');
            $(this).parent().addClass('open');
        }
    });
}

function createItem(ul, item) {
    var li = document.createElement('li');
    var a = document.createElement('a');
    a.href = item.url;
    a.innerHTML = item.name;
    li.appendChild(a);
    if (item.items && item.items.length > 0) {
        var s = document.createElement('span');
        a.appendChild(s);
        var subUl = document.createElement('ul');
        li.appendChild(subUl);

        li.className = 'dropdown';
        a.className = 'dropdown-toggle';
        a.setAttribute('data-toggle', 'dropdown');
        s.className = 'caret';
        subUl.className = 'dropdown-menu';
        subUl.setAttribute('role', 'menu');
        for (var i = 0; i < item.items.length; i++) {
            createItem(subUl, item.items[i]);
        }
    }
    ul.appendChild(li);
}

