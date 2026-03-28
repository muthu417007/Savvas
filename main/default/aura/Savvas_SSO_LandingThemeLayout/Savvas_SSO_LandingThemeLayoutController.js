({
    //redirect to company site onclick of company logo
    redirectToHome : function(component, event, helper) {
        var url = $A.get("$Label.c.Sitecore_URL_to_whitelist");
        window.open(url);
    },
    //set the banner url in home page
    doInit : function(component, event, helper) {
        var bannerImageUrl = $A.get('$Resource.Savvas_SSO_Images') + '/Images/Savvas_SSO_BannerImage.png';
        var mobileBannerImageURL = $A.get('$Resource.Savvas_SSO_Images') + '/Images/Savvas_SSO_MobileBanner.png';
        component.set('v.bannerImageURL', bannerImageUrl);
        component.set('v.mobileBannerImageURL', mobileBannerImageURL);
        window.screen.width>600?component.set('v.isMobile', false):component.set('v.isMobile', true);
    }
})