import { Contact, State } from "../interfaces";

export class Events {
    id?: number;
    dateEntered?: Date;
    startDate?: Date;
    endDate?: Date;
    title?: string;
    description?: string;
    descriptionParagraphs?: string[];
    state?: State;
    contactCreate?: Contact;
    contactAudit?: Contact;
    imageUrl?: string;
    assist?: boolean;
    attendeesCount?: number;
    contacts: Contact[];

    constructor() {
        this.id = 0;
        this.dateEntered = null;
        this.startDate = null;
        this.endDate = null;
        this.title = null;
        this.description = null;
        this.descriptionParagraphs = [];
        this.state = null;
        this.contactCreate = null;
        this.contactAudit = null;
        this.imageUrl = null;
        this.assist = false;
        this.contacts = [];
    }
}