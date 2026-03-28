import { LightningElement,track } from 'lwc';

export default class Scc_customAccordion extends LightningElement {

    @track sections = [
        { id: 1, title: 'Section 1', content: 'Content for Section 1', isOpen: false },
        { id: 2, title: 'Section 2', content: 'Content for Section 2', isOpen: false },
        // Add more sections as needed
    ];

    toggleSection(event) {
        const sectionId = event.currentTarget.dataset.sectionId;
        this.sections = this.sections.map(section => {
            if (section.id === parseInt(sectionId)) {
                return { ...section, isOpen: !section.isOpen };
            }
            return section;
        });
    }

}