import { LightningElement } from "lwc";
import ensxtx_poweredByEnosixLogo from "@salesforce/resourceUrl/ensxtx_poweredByEnosixLogo";

export default class MiscStaticResource extends LightningElement {

    ensxtx_poweredByEnosixLogo = ensxtx_poweredByEnosixLogo;

    onLogoClick(event) {
        if (event.shiftKey && (event.ctrlKey || event.metaKey)) {
            this.dispatchEvent(new CustomEvent('logoclick', {}))
        }
    }
}