//fix for IE 8
if (typeof String.prototype.trim != 'function') {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    };
}

var isPosting = false;
var $xiForm;
var $xiProperties;
var submitOrigin;
var submitting = false;
var ctrlDown = false;
var shiftDown = false;

$(document).ready(function () {
    AddRepeatPolyfill();

    $xiForm = $("[xi-mhtml-form='1']:first");
    if ($xiForm.attr("xi-form-parent") === "none") {
        if (window.self !== window.top) {
            window.top.location.href = window.location.href + "?errorIframe=true";
        }
    }
    $xiForm.groupValidations = {};

    $('form input:not(:submit)').keypress(function (e) {
        if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
            if (submitting)
                return false;
            submitOrigin = this;
            submitting = true;

            $xiForm.submit();
            return false;
        }
    });

    $("[xi-submit]").click(function () {
        if (submitting)
            return false;
        submitOrigin = this;
        submitting = true;
    });

    $xiForm.on('submit', function () {
        // check validation
        if (!submitOrigin || submitOrigin.name === "cancel-btn") {
            $xiForm.validate().cancelSubmit = true;
            return true;
        }

        submitOrigin = null;
        if (!validateForm()) {
            submitting = false;
            return false;
        }

        if (cardinalThreeDSVersion > 1) {
            $CardinalDdc.ddcInitiate({
                form: $xiForm[0],
                type: "POST",
                data: getPageXiPackage(),
                ddcUrl: cardinalDdcUri,
                ddcError: function (options) {
                    options.form.submit();
                },

                ddcSuccess: function (result, options) {
                    var clientDeviceData = options.data.DeviceData
                                               ? JSON.stringify(options.data.DeviceData)
                                               : "";

                    $("input[name='ClientDeviceData']").val(clientDeviceData);

                    options.form.submit();
                }
            });
            return false;
        }
        else {
            return true;
        }
    });

    setupXiProps();
    initHtml();
    SetupValidation();

    $("input[type='tel'][apply-mask!='true'], input[name='c-cn'][apply-mask!='true']").keydown(function (e) {
        if (e.which === 17) {//ctrl key
            ctrlDown = true;
            return true;
        }
        if (ctrlDown) {
            if (e.which !== 17) ctrlDown = false;
            return true;
        }
        //arrow keys, backspace, delete
        if (e.which === 35 || e.which === 36 || e.which === 8 || e.which === 46 || e.which === 37 || e.which === 39 || e.which === 9) {
            return true;
        }
        //number keys
        if (e.which >= 48 && e.which <= 57) {
            return true;
        }
        //number pad keys
        if ((e.which >= 96 && e.which <= 105)) {
            return true;
        }
        return false;
    });
    $("input[type='tel'][apply-mask!='true'], input[name='c-cn'][apply-mask!='true']").on('input', function () {
        if (/^\d+$/.test($(this).val())) return;
        //remove everything but digits from number inputs
        $(this).val($(this).val().replace(/\D/g, ''));
    });
    //autoSizeIFrame();
});

var xiConstant = {
    merchantGuid: "merchantGuid",
    accessToken: "accessToken",
    echeck: "echeck",
    card: "card",
    amex: "ax",
    discover: "di",
    jcb: "jc",
    maestro: "sw",
    mastercard: "mc",
    visa: "vi"
};
var xiElement = {
    cardNumber: "c-cn",
    expMonth: "c-exmth",
    expYear: "c-exyr"
};

function setupXiProps() {
    var $xip = $("#xi-properties");
    if (!$xip.length) {
        $xiProperties = {};
        return;
    }
    $xiProperties = jQuery.parseJSON($xip.val());
    $xiForm.xiErrorClass = $xiProperties.ErrorClass;
}
function setupTooltip(element) {
    element.tooltip();
    element.tooltip("option", "tooltipClass", $xiProperties.ErrorTooltip.Class);

    if ($xiProperties.ErrorTooltip.ShowEffect) {
        element.tooltip("option", "show", { effect: $xiProperties.ErrorTooltip.ShowEffect, duration: $xiProperties.ErrorTooltip.ShowDuration });
    }

    if ($xiProperties.ErrorTooltip.HideEffect) {
        element.tooltip("option", "hide", { effect: $xiProperties.ErrorTooltip.HideEffect, duration: $xiProperties.ErrorTooltip.HideDuration });
    }

    element.tooltip("option", "position",
        {
            my: $xiProperties.ErrorTooltip.PositionMy === null ? "left+15 bottom" : $xiProperties.ErrorTooltip.PositionMy,
            at: $xiProperties.ErrorTooltip.PositionAt === null ? "left top" : $xiProperties.ErrorTooltip.PositionAt,
            collision: $xiProperties.ErrorTooltip.Collision === null ? "flipfit" : $xiProperties.ErrorTooltip.Collision
        });
}
function initHtml() {
    paymentOptionChanged(true);
    getSelectedValue("c-ct-select", true);

    $("#c-amt").keyup(cardAmountChange);
    $("input[type='radio'][xi-group='po-po-select']").click(paymentOptionChanged);
    $("select[xi-group='po-po-select']").change(paymentOptionChanged);

    $("input[type='radio'][xi-group='c-ct-select']").click(cardTypeChanged);
    $("select[xi-group='c-ct-select']").change(cardTypeChanged);
    $("input[type='radio'][xi-group='ec-at-select']").click(eCheckAccountTypeChanged);
    $("select[xi-group='ec-at-select']").change(eCheckAccountTypeChanged);
    $("[name='c-cn']").keyup(function (e) { cardNumberChanged($(this), e); cardTypeChangedForIndicator($(this)); });
    $("[name='" + xiElement.cardNumber + "'][apply-mask='true']").keydown(function (e) {
        try {
            if (e &&
                ((!e.key && !String.fromCharCode(e.which).match(/(\w|\s)/g) && e.which !== 8 && e.which !== 46) ||
                    (e.key.length !== 1 &&
                        e.key.toLowerCase() !== "backspace" &&
                        e.key.toLowerCase() !== "delete" &&
                        e.key.toLowerCase() !== "enter" &&
                        e.key.toLowerCase() !== "tab")))
                return true;
            else {
                return PreformatCardNumber($(this), e);
            }
        } catch (ex) {
            return true;
        }
    });
    $("[name='c-cn']").blur(function (e) {
        cardNumberChanged($(this), e, true);
    });
    $("[name='" + xiElement.cardNumber + "'][apply-mask='true']").on("paste", function () {
        try {
            var ccTextbox = $(this);
            var originalCaretPosition = GetCaretPosition(this);

            setTimeout(function () {
                var newCaretPosition = GetCaretPosition(ccTextbox[0]);
                var pastedText = GetPastedText($(ccTextbox).val(), originalCaretPosition, newCaretPosition);

                if (pastedText.length > 0)
                    FormatCardNumber(ccTextbox, null, pastedText.length);
            });
        } catch (ex) {
            return;
        }
    });

    $("[name='c-ct'], [name = 'c-cn'], [name = 'c-chn'], [name = 'c-exmth'],[name = 'c-exyr'], [name = 'c-cvv']," +
        "[name='ec-acnum'], [name='ec-rtnum'], [name='ec-noa'], [name='ec-bn'], [name='ec-at']," +
        "[name='address1'], [name='city'], [name='us-state'], [name='postalCode']")
        .on('focus', function (element) {
            if ($(this) !== undefined && $(this).length > 0) {
                var elementId = "";
                if ($(this).attr("id") === "postalCode")
                    elementId = "postalcode-error";
                else if ($(this).attr("id") === "ec-at-savings" || $(this).attr("id") === "ec-at-checking")
                    elementId = "ec-at-error";
                else
                    elementId = $(this).attr("id") + "-error";

                if ($(this).attr("id") !== 'c-exyr')
                    ValidateControlForReader($(this), elementId);
                else 
                    ValidateExpYrControlForReader($(this), elementId);
            }
        });
}

function ValidateControlForReader(control, elementId) {
    if (control.attr('aria-describedby') !== undefined) {
        control.valid();
        $('#' + elementId).attr('aria-live', 'polite');
    }
}
function ValidateExpYrControlForReader(control, elementId) {
    if (control.attr('aria-describedby') !== undefined && $('#'+elementId).attr('aria-live') === '') {
        control.valid();
        $('#' + elementId).attr('aria-live', 'polite');
    }
}
function cardAmountChange() {
    $IFrameClientSettings.cardAmountChange(this);
}

function paymentOptionChanged(isInitLoad) {
    isInitLoad = isInitLoad || false;
    var val = getSelectedValue("po-po-select");
    if (!val) {
        //default to card
        $("[xi-group='po-po-select'] option:not([value='echeck']):first").attr("selected", "true");
        $("[xi-group='po-po-select']:not([value='echeck']):first").attr("checked", "checked");
        val = getSelectedValue("po-po-select");
        if (!val) {//default to first available
            $("[xi-group='po-po-select'] option:first").attr("selected", "true");
            $("[xi-group='po-po-select']:first").attr("checked", "checked");
            val = getSelectedValue("po-po-select");
        }
    }
    if (val)
        val = val.toLowerCase();

    var showparent;
    var hideparent;
    switch (val) {
        case xiConstant.echeck:
            showparent = $("[name='ec-content']:first");
            hideparent = $("[name='c-content']:first");
            hideparent.hide();
            showparent.show();
            break;
        default:
            showparent = $("[name='c-content']:first");
            hideparent = $("[name='ec-content']:first");
            hideparent.hide();
            showparent.show();
            getSelectedValue("c-ct-select", true);
            break;
    }

    enableXiControls(showparent, false);
    enableXiControls(hideparent, true);

    if (!isInitLoad)
        autoSizeIFrame();
}
function enableXiControls($parent, disabled) {
    $parent.find("input,select").prop('disabled', disabled);
}
function cardTypeChanged() {
    getSelectedValue("c-ct-select", true);
    if ($xiForm.validateInteractive || $xiProperties.InlineValidation)
        $xiForm.valid();
    autoSizeIFrame();
    $IFrameClientSettings.cardTypeChange(this);

    FormatCardNumber($("[name='" + xiElement.cardNumber + "']"));
}
function cardTypeChangedForIndicator(cnTextBox) {
    var $cardIndGroup, cardTypeValue = "";
    $cardIndGroup = $("div[xi-group='c-ct-select']:first");
    if ($cardIndGroup && $cardIndGroup.length > 0) {
        if (cnTextBox.val() !== null && cnTextBox.val() !== "")
            cardTypeValue = getSelectedValue("c-ct-select", true);

        $IFrameClientSettings.cardTypeChangeForIndicator(cardTypeValue);
    }
}

function eCheckAccountTypeChanged() {
    getSelectedValue("ec-at-select", true);
    autoSizeIFrame();
}

function cardNumberChanged(textbox, event, leavingTextbox) {
    if (!textbox)
        textbox = $("[name='c-cn']");

    var cardInd = $("div[xi-group='c-ct-select']:first");
    if (cardInd) {
        var cnval = textbox.val();
        $("div[xi-group='c-ct-select'] div").each(function () {
            if (cnval === null || cnval === "") {
                $(this).removeClass("selected");
                $(this).removeClass("unselected");
            } else {
                var reg = new RegExp($(this).attr("bin-range-expression"));
                if (reg.test(cnval)) {
                    $(this).removeClass("unselected");
                    $(this).addClass("selected");
                } else {
                    $(this).removeClass("selected");
                    $(this).addClass("unselected");
                }
            }
        });
        getSelectedValue("c-ct-select", true);
        autoSizeIFrame();
    }

    if (event && event.ctrlKey) {
        return;
    }
    FormatCardNumber(textbox, event, 0, leavingTextbox);
}

var formattedCardTypes = [
    { cardType: xiConstant.amex, format: "4-6-5" }
];

function PreformatCardNumber(textbox, e) {
    if (e && e.ctrlKey)
        return true;

    if (e
        && ((!e.key
            && !String.fromCharCode(e.which).match(/ /g))
            || (e.key === " " || e.key.toLowerCase() === "spacebar")))
        return false;

    if (e
        && ((!e.key
            && !String.fromCharCode(e.which).match(/\s/g))
            || (e.key.toLowerCase() === "enter"
                || e.key.toLowerCase() === "tab")))
        return true;

    var cardNumber;
    var format;
    var parsedFormat;
    var checkedLength;
    var currentCaretPosition = GetCaretPosition(textbox[0]);

    //Adding a character
    if ((!e
        || (e.key
            || (e.which !== 8
                && e.which !== 46)))
        && (e.key.toLowerCase() !== "backspace"
            && e.key.toLowerCase() !== "delete")) {

        if (textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").length > 0
            && e
            && ((!e.key
                && (String.fromCharCode(e.which).match(/\D/g) || (String.fromCharCode(e.which).match(/\d/g) && e.shiftKey)))
                || (e.key.length !== 1 || e.key.match(/\D/g))))
            return false;

        if (textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").length > 0)
            cardNumber = textbox.val().replace(/\D/g, "");
        else
            cardNumber = textbox.val().replace(/\s/g, "");

        format = GetFormat(cardNumber);
        parsedFormat = ParseFormat(format);

        var moveCaretExtraPosition = false;
        checkedLength = 0;
        for (var i in parsedFormat) {
            checkedLength += parsedFormat[i];

            if (cardNumber.length === checkedLength)
                textbox.val(textbox.val() + " ");

            if (currentCaretPosition.start - i === checkedLength) {
                moveCaretExtraPosition = true;
            }

            if (cardNumber.length < checkedLength)
                break;
        }

        if (textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").length > 0)
            textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").val(textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").val().replace(/[^0-9\s]/g, ""));

        if (moveCaretExtraPosition) {
            SetCaretPosition(textbox[0], currentCaretPosition.start + 1, currentCaretPosition.end + 1);
        } else {
            SetCaretPosition(textbox[0], currentCaretPosition.start, currentCaretPosition.end);
        }

        return true;
    }
    //Removing a character
    else {

        var isBackspace = false;
        if ((!e.key
            && e.which === 8)
            || e.key.toLowerCase() === "backspace")
            isBackspace = true;

        var removeStartPosition = currentCaretPosition.start;
        var removeEndPosition = currentCaretPosition.end;

        //Backspace
        if (isBackspace
            && currentCaretPosition.start === currentCaretPosition.end)
            removeStartPosition = currentCaretPosition.start - 1;
        //Delete
        else if (!isBackspace
            && currentCaretPosition.start === currentCaretPosition.end) {
            removeEndPosition = currentCaretPosition.end + 1;
        }

        cardNumber = textbox.val().substring(0, removeStartPosition) + textbox.val().substring(removeEndPosition);

        if (textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").length > 0)
            cardNumber = cardNumber.replace(/\D/g, "");
        else
            cardNumber = cardNumber.replace(/\s/g, "");

        format = GetFormat(cardNumber);
        cardNumber = PerformFormat(cardNumber, format);

        if (textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").length > 0)
            cardNumber = cardNumber.replace(/[^0-9\s]/g, "");

        textbox.val(cardNumber);

        if (isBackspace) {
            if (currentCaretPosition.start === currentCaretPosition.end)
                SetCaretPosition(textbox[0], currentCaretPosition.start - 1, currentCaretPosition.start - 1);
            else
                SetCaretPosition(textbox[0], currentCaretPosition.start, currentCaretPosition.start);
        } else {
            SetCaretPosition(textbox[0], currentCaretPosition.start, currentCaretPosition.start);
        }

        return false;
    }
}
function FormatCardNumber(textbox, e, numberOfPastedCharacters, leavingTextbox) {
    try {
        if (textbox.filter("[apply-mask='true']").length === 0
            || textbox.filter("[apply-mask='true']").val().length === 0)
            return;

        if (e && ((!e.key && !String.fromCharCode(e.which).match(/(\w|\s)/g)) || e.key.length !== 1))
            return;

        if (e &&
            ((!e.key && !String.fromCharCode(e.which).match(/\s/g)) ||
                (e.key.toLowerCase() === "enter" || e.key.toLowerCase() === "tab")))
            return;

        if (!numberOfPastedCharacters)
            numberOfPastedCharacters = 0;

        if (typeof leavingTextbox === "undefined")
            leavingTextbox = false;

        var cardNumber;
        if (textbox.filter("input[type='tel'],input[inputmode='numeric'][type='text']").length > 0)
            cardNumber = textbox.val().replace(/\D/g, "");
        else
            cardNumber = textbox.val().replace(/\s/g, "");

        var format = GetFormat(cardNumber);
        cardNumber = PerformFormat(cardNumber, format);

        var currentCaretPosition = GetCaretPosition(textbox[0]);

        var moveCaretExtraPositions = 0;
        if (!leavingTextbox && currentCaretPosition.start - numberOfPastedCharacters < textbox.val().length - 1) {
            var parsedFormat = ParseFormat(format);

            var checkedLength = 0;
            for (var j in parsedFormat) {
                checkedLength += parsedFormat[j];

                //If this isn't a paste and the cursor is at the end of a section in the format
                if (numberOfPastedCharacters === 0 && currentCaretPosition.start === checkedLength) {
                    moveCaretExtraPositions++;
                    break;
                }
                //For paste
                //If this is a paste and the paste started before the current format section
                //And the end of the paste is at the end of the format section or after
                //Non-paste
                //If this isn't a paste and the cursor needs to move between format sections
                else if (currentCaretPosition.start - numberOfPastedCharacters <= checkedLength &&
                    currentCaretPosition.start >= checkedLength) {
                    moveCaretExtraPositions++;
                }

                //Add one to the checked length to account for the space between formatted sections
                checkedLength++;
            }
        }

        textbox.val(cardNumber);

        if (!leavingTextbox) {
            if (moveCaretExtraPositions > 0)
                SetCaretPosition(textbox[0],
                    currentCaretPosition.start + moveCaretExtraPositions,
                    currentCaretPosition.end + moveCaretExtraPositions);
            else
                SetCaretPosition(textbox[0], currentCaretPosition.start, currentCaretPosition.end);
        }
    }
    catch (ex) {
        return;
    }
}

function GetFormat(cardNumber) {
    var cardType = getSelectedValue("c-ct-select", false);

    var formatFound = false;
    var format = "";
    if (cardType != null) {
        $.each(formattedCardTypes,
            function () {
                if (!formatFound && this.cardType === cardType) {
                    formatFound = true;
                    format = this.format;

                    var parsedFormat = ParseFormat(format);

                    var totalFormattedLength = 0;
                    for (var j in parsedFormat) { totalFormattedLength += parsedFormat[j]; }
                    if (cardNumber.length > totalFormattedLength) {
                        format += "-";
                        format += "4-".repeat(Math.ceil((cardNumber.length - totalFormattedLength) / 4)).toString().replace(/-$/, "");
                    }
                }
            });
    }

    if (!formatFound)
        format = GetDefaultFormat(cardNumber);

    return format;
}
function ParseFormat(format) {
    var formatStrings = format.split("-");
    var parsedFormat = [];
    for (var i in formatStrings)
        parsedFormat.push(parseInt(formatStrings[i]));

    return parsedFormat;
}
function GetDefaultFormat(cardNumber) {
    var format = "4-".repeat(Math.ceil(cardNumber.length / 4)).toString();
    return format.replace(/-$/, "");
}
function PerformFormat(cardNumber, format) {
    var formattedCardNumber = "";
    var totalLengthFormmated = 0;

    var parsedFormat = ParseFormat(format);

    $.each(parsedFormat, function () {
        var segmentLength = this;
        formattedCardNumber += cardNumber.substring(totalLengthFormmated, totalLengthFormmated + segmentLength) + " ";
        totalLengthFormmated += segmentLength;
    });

    return formattedCardNumber.trim();
}


function getSelectedValue(name, displayFields) {
    var val = $("select[xi-group='" + name + "']:first").val();
    if (val) {
        if (displayFields) {
            displayFieldElements($("select[xi-group='" + name + "'] option[value='" + val + "']"));
        }
        return val;
    }
    val = $("input[type='radio'][xi-group='" + name + "']:checked").val();
    if (val) {
        if (displayFields) {
            displayFieldElements($("input[type='radio'][xi-group='" + name + "'][value='" + val + "']"));
        }
        return val;
    }
    val = $("select[name='" + name + "']:first").val();
    if (val) {
        if (displayFields) {
            displayFieldElements($("select[name='" + name + "'] option[value='" + val + "']"));
        }
        return val;
    }
    val = $("input[type='radio'][name='" + name + "']:checked").val();
    if (val) {
        if (displayFields) {
            displayFieldElements($("input[type='radio'][name='" + name + "'][value='" + val + "']"));
        }
        return val;
    }

    var $cardIndGroup
    if(name == "c-ct")
        $cardIndGroup = $("div[xi-group='c-ct-select']:first");
    else
        $cardIndGroup = $("div[xi-group='" + name + "']:first")

    if ($cardIndGroup && $cardIndGroup.length > 0) {
        $("div[xi-group='c-ct-select'] div").each(function () {
            val = null;
            if ($(this).hasClass("selected")) {
                val = $(this).attr("xi-valid-for");

                if (displayFields) {
                    displayFieldElements($(this));
                }
                return false;
            }
            return true;
        });

        if (val) {
            if (!$("#hiddenCardType").length) {
                $cardIndGroup.append(
                    $('<input>',
                        {
                            id: 'hiddenCardType',
                            type: 'hidden',
                            name: $cardIndGroup.attr("name"),
                            val: val
                        })
                );
            } else {
                $("#hiddenCardType").val(val);
            }

        }

        return val;
    }

    return val;
}
function displayFieldElements(elem) {
    var hideFields = elem.attr("xi-hide-fields");
    var aryHide = [];
    if (hideFields) aryHide = hideFields.split(";");
    $("[xi-elem]").each(function () {
        var tmpElem = $(this);
        var hide = false;
        $(aryHide).each(function () {
            if (this == tmpElem.attr("xi-elem")) {
                hide = true;
                return false;
            }
        });
        if (hide) {
            $("[xi-elem='" + tmpElem.attr("xi-elem") + "']").hide();
        } else {
            $("[xi-elem='" + tmpElem.attr("xi-elem") + "']").show();
        }
    });
}

function SetupValidation() {
    $.validator.addMethod(
        "expdate",
        function (value, element) {
            return expDateChk(element);
        }, "Please enter a valid date");
    $.validator.addMethod(
        "startdate",
        function (value, element) {
            return startDateChk(element);
        }, "Please enter a valid date");

    $.validator.addMethod(
        "luhncheck",
        function (value, element, param) {
            return cardLuhnChk(param);
        }, "Invalid luhn");

    $xiForm.validate({
        ignore: ":hidden",
        errorElement: 'span',
        showErrors: function (errorMap, errorList) {
            var invalidCtrl = [];
            $.each(errorList, function (index, error) {
                var element = $(error.element);
                var data = { name: element[0].name, definedName: element[0].getAttribute("xi-name"), message: error.message };
                invalidCtrl.push(data);
                if (!element.attr("xi-error-class"))
                    element.attr("xi-error-class", $xiProperties.ErrorClass);
                switch (element.attr("xi-error-msg-style")) {
                    case "inputTooltip":
                        element.attr("title", error.message);
                        setupTooltip(element);
                        break;
                    case "imageTooltip":
                        var $forMsg = $("[data-msg-for='" + element.attr("id") + "']:first");
                        if ($forMsg.length) {
                            var validClass = $forMsg.attr("class");
                            if (validClass === undefined) validClass = "";
                            if ($forMsg.attr("xi-valid-class") === undefined)
                                $forMsg.attr("xi-valid-class", validClass);
                            $forMsg.removeClass(validClass).addClass($forMsg.attr("xi-error-class"));
                            $forMsg.attr("title", error.message);
                            setupTooltip($forMsg);
                        }
                        break;
                    case "text":
                        $forMsg = $("[data-msg-for='" + element.attr("id") + "']:first");
                        if ($forMsg.length > 0)
                            $forMsg.text(error.message);
                        break;
                }
            });
            this.defaultShowErrors();
            autoSizeIFrame();

            if (invalidCtrl.length > 0)
                $IFrameClientSettings.onInvalidHandler(invalidCtrl);

        },
        success: function (label, element) {
            var $element = $(element);
            switch ($element.attr("xi-error-msg-style")) {
                case "inputTooltip":
                    $element.tooltip();
                    $element.tooltip('disable');
                    return;
                case "imageTooltip":
                    var $forMsg = $("[data-msg-for='" + $element.attr("id") + "']:first");
                    if ($forMsg.length) {
                        $forMsg.removeClass($forMsg.attr("xi-error-class")).addClass($forMsg.attr("xi-valid-class"));
                        $forMsg.tooltip();
                        $forMsg.tooltip('disable');
                    }
                    return;;
                case "text":
                    $forMsg = $("[data-msg-for='" + $element.attr("id") + "']:first");
                    if ($forMsg.length > 0)
                        $forMsg.text("");
                    return;
            }
            autoSizeIFrame();
        },
        errorPlacement: function (error, element) {
            //ignore if msg is a tooltip or has a validation msg control
            if (element.attr("xi-error-msg-style") !== "text")
                return;
            if ($("[data-msg-for='" + element.attr("id") + "']:first").length)
                return;
            error.insertAfter(element);//default show after element
        }
    });

    $xiForm.data("validator").settings.highlight = function (element) {
        $(element).addClass($(element).attr("xi-error-class"));
    };

    $xiForm.data("validator").settings.unhighlight = function (element) {
        $(element).removeClass($(element).attr("xi-error-class"));
    };

    setupValidationsForElement();

    $xiForm.data("validator").settings.onkeyup = false;
    $xiForm.data("validator").settings.onfocusout = function (element) {
        if (!$xiProperties.InlineValidation || !$(element).rules()) return;
        if (element.name === 'c-cn')
            cardNumberChanged($(element), null, true);
        $(element).valid();
    };
}
function validateForm() {
    //once form has been 'submitted', turn on real-time validations
    $xiForm.validateInteractive = true;
    $xiForm.data("validator").settings.onfocusout = function (element) {
        var $element = $(element);
        if ($element.is("input:text") || $element.is("input[type=tel]")) {
            if ($element !== undefined && $element.length > 0) {
                var elementId = $element.attr("id") + "-error";
                $('#' + elementId).attr('aria-live', '');
            }
            $element.valid();
        }
    };
    $xiForm.data("validator").settings.onclick = function (element) {
        var $element = $(element);
        if ($element.is('select'))
            $element.valid();
    };

    var isvalid = $xiForm.valid();
    autoSizeIFrame();
    return isvalid;
}


function setupValidationsForElement() {
    var elem = $("#valid-for-data");
    if (!elem)
        return;

    var forElems = jQuery.parseJSON(elem.val());

    $.each(forElems, function (index, forElem) {
        $.each(forElem.Rules, function (index, forRule) {
            elem = $("[name='" + forRule.For + "']");
            if (!elem || elem.length === 0)
                return;
            if (forRule.DefaultRuleParam === undefined || forRule.DefaultRuleParam === null)
                forRule.DefaultRuleParam = elem.rules()[forRule.RuleName];
            if (forRule.DefaultRuleParam === undefined || forRule.DefaultRuleParam === null)
                forRule.DefaultRuleParam = false;

            forRule.defaultMessage = elem.attr("data-msg-" + forRule.RuleName);
            var ruleparams = {};
            ruleparams[forRule.RuleName] = function () { return getControllerRuleParam(forRule); };
            elem.rules("add", ruleparams);
        });
    });
}
function getControllerRuleParam(rule) {
    var result;
    $.each(rule.Controllers, function (index, controller) {
        if ((controller.For == controller.ControllerName &&
            controller.ControllerValue == null) ||
            getSelectedValue(controller.ControllerName) === controller.ControllerValue) {
            result = controller.RuleValue;
            if (!$xiForm.validate().settings.messages[rule.For])
                $xiForm.validate().settings.messages[rule.For] = {};
            $xiForm.validate().settings.messages[rule.For][rule.RuleName] = controller.Message;
            return false;//break each
        }
    });
    if (result === undefined) {
        result = rule.DefaultRuleParam;
        if ($xiForm.validate().settings.messages[rule.For] === undefined)
            $xiForm.validate().settings.messages[rule.For] = {};
        $xiForm.validate().settings.messages[rule.For][rule.RuleName] = rule.defaultMessage;
    }

    switch (result) {
        case undefined:
            return "";
        case "true":
            return true;
        case "false":
            return false;
        default:
            return result;
    }
}

var x;

function expDateChk(element) {
    if (!$xiForm.groupValidations.expDateCheckEnabled) {
        var $groupElem = ($(element).attr("name") === "c-exmth") ? $("[name='c-exyr']") : $("[name='c-exmth']");
        $groupElem.change(function () {
            $(element).valid();
        });
        $groupElem.blur(function () {
            if ($groupElem !== undefined && $groupElem.attr("name") === "c-exyr") {
                var elementId = $groupElem.attr("id") + "-error";
                $('#' + elementId).attr('aria-live', '');
            }
            $(element).valid();
        });
        $(element).change(function () {
            $groupElem.valid();
        });
        $(element).blur(function () {
            if ($(element) !== undefined && ($(element).attr("name") === "c-exmth" || $(element).attr("name") === "c-exyr")) {
                var elementId = $(element).attr("id") + "-error";
                $('#' + elementId).attr('aria-live', '');
            }
            $groupElem.valid();
        });
        $xiForm.groupValidations.expDateCheckEnabled = true;
    }

    var date = new Date();
    var minMonth = date.getMonth() + 1;
    var minYear = parseInt(date.getFullYear().toString(), 10);
    var monthval = $("[name='c-exmth']").val();
    var yearval = $("[name='c-exyr']").val();
    if (monthval === null || yearval === null || !$.isNumeric(monthval) || !$.isNumeric(yearval))
        return false;

    var month = parseInt(monthval, 10);
    if (month !== Number(monthval)) return false;
    if (month < 1 || month > 12) return false;

    var year = parseInt(yearval, 10);
    if (year !== Number(yearval)) return false;
    if (year < 0) return false;
    if (year < 100) year = 2000 + year;

    return ((year > minYear) || ((year === minYear) && (month >= minMonth)));
}

function startDateChk(element) {
    if (!$xiForm.groupValidations.startDateCheckEnabled) {
        var $groupElem = ($(element).attr("name") === "c-stmth") ? $("[name='c-styr']") : $("[name='c-stmth']");
        $groupElem.change(function () {
            $(element).valid();
        });
        $groupElem.blur(function () {
            $(element).valid();
        });
        $xiForm.groupValidations.startDateCheckEnabled = true;
    }
    var date = new Date();
    var maxMonth = date.getMonth() + 1;
    var maxYear = parseInt(date.getFullYear().toString(), 10);
    var monthval = $("[name='c-stmth']").val();
    var yearval = $("[name='c-styr']").val();
    if (monthval === null || yearval === null || !$.isNumeric(monthval) || !$.isNumeric(yearval))
        return false;

    var month = parseInt(monthval, 10);
    if (month !== Number(monthval)) return false;
    if (month < 1 || month > 12) return false;

    var yearLen = yearval.length;
    if (yearLen !== 2 && yearLen !== 4) return false;
    var year = parseInt(yearval, 10);
    if (year !== Number(yearval)) return false;
    if (year < 0) return false;

    if (year < 100) {
        //if 2 digit year is 80 or greater, it will be treated as 19XX
        //All other 2-digit entries of XX will be treated as 20XX
        if (year >= 80) {
            year = 1900 + year;
        } else {
            year = 2000 + year;
        }
    }
    return ((year < maxYear) || ((year === maxYear) && (month <= maxMonth)));
}

function cardLuhnChk(params) {
    try {
        var luhnConst = {
            enabled: 'datavalue',
            tokenformat: 'tokenformat'
        }

        if (!getBool(params[luhnConst.enabled]))
            return true;

        var ccTextbox = $("[name='" + xiElement.cardNumber + "']");

        var cnum = ccTextbox.val().trim();

        if (ccTextbox.filter("[apply-mask='true']").length > 0)
            cnum = cnum.replace(/\s/g, "");

        if (tokenEntryRegexValidation(cnum, params[luhnConst.tokenformat]))
            return true;

        var len = cnum.length,
            mul = 0,
            prodArr = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]],
            sum = 0;

        while (len--) {
            sum += prodArr[mul][parseInt(cnum.charAt(len), 10)];
            mul ^= 1;
        }
        return sum % 10 === 0 && sum > 0;
    } catch (ex) {
        return true;
    }
}

function autoSizeIFrame(delay) {
    if (typeof ($XIFrame) === "undefined" || !$XIFrame)
        return;

    if (!delay)
        delay = 0;

    setTimeout(function () {
        var htmlDiv = $('#html-main-content');
        if (htmlDiv) {
            $("html").width(htmlDiv.outerWidth());
            $("html").height(htmlDiv.outerHeight());
            $XIFrame.resize(htmlDiv.outerHeight(), htmlDiv.outerWidth());
        }
    }, delay);
}

function tokenEntryRegexValidation(entryVal, tokenRegex) {
    try {
        if (typeof (tokenRegex) === "undefined" || !tokenRegex)
            return false;

        var regex = new RegExp(tokenRegex);
        if (regex.test(entryVal))
            return true;
    }
    catch (ex) {
        return false;
    }
}

function getBool(val) {
    return !!JSON.parse(String(val).toLowerCase());
}

//Via https://blog.vishalon.net/javascript-getting-and-setting-caret-position-in-textarea
function GetCaretPosition(ctrl) {
    // IE < 9 Support
    if (document.selection) {
        ctrl.focus();
        var range = document.selection.createRange();
        var rangelen = range.text.length;
        range.moveStart('character', -ctrl.value.length);
        var start = range.text.length - rangelen;
        return { 'start': start, 'end': start + rangelen };
    }
    // IE >=9 and other browsers
    else if (ctrl.selectionStart || ctrl.selectionStart == '0') {
        return { 'start': ctrl.selectionStart, 'end': ctrl.selectionEnd };
    } else {
        return { 'start': 0, 'end': 0 };
    }
}
function SetCaretPosition(ctrl, start, end) {
    // IE >= 9 and other browsers
    if (ctrl.setSelectionRange) {
        ctrl.setSelectionRange(start, end);
    }
    // IE < 9
    else if (ctrl.createTextRange) {
        var range = ctrl.createTextRange();
        range.collapse(true);
        range.moveEnd('character', end);
        range.moveStart('character', start);
        range.select();
    }
}

function GetPastedText(newValue, originalCaretPosition, newCaretPosition) {
    return newValue.substring(originalCaretPosition.start, newCaretPosition.start);
}

//https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/repeat
function AddRepeatPolyfill() {
    if (!String.prototype.repeat) {
        String.prototype.repeat = function (count) {
            'use strict';
            if (this == null)
                throw new TypeError('can\'t convert ' + this + ' to object');

            var str = '' + this;
            // To convert string to integer.
            count = +count;
            // Check NaN
            if (count != count)
                count = 0;

            if (count < 0)
                throw new RangeError('repeat count must be non-negative');

            if (count == Infinity)
                throw new RangeError('repeat count must be less than infinity');

            count = Math.floor(count);
            if (str.length == 0 || count == 0)
                return '';

            // Ensuring count is a 31-bit integer allows us to heavily optimize the
            // main part. But anyway, most current (August 2014) browsers can't handle
            // strings 1 << 28 chars or longer, so:
            if (str.length * count >= 1 << 28)
                throw new RangeError('repeat count must not overflow maximum string size');

            var maxCount = str.length * count;
            count = Math.floor(Math.log(count) / Math.log(2));
            while (count) {
                str += str;
                count--;
            }
            str += str.substring(0, maxCount - str.length);
            return str;
        }
    }
}

function OnKeyUp(event, id) {
    if (event.key === " " || event.key === "Enter") {
        var button = document.getElementById(id);
        if (button !== undefined)
            button.click();
    }
}