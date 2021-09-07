import { Contact, State } from "../intrergaces";

export class Events {
    id?: number;
    dateEntered?: Date;
    startDate?: Date;
    endDate?: Date;
    title?: string;
    description?: string;
    state?: State;
    contactCreate?: Contact;
    contactAudit?: Contact;

    constructor() {
        this.id = 0;
        this.dateEntered = null;
        this.startDate = null;
        this.endDate = null;
        this.title = null;
        this.description = null;
        this.state = null;
        this.contactCreate = null;
        this.contactAudit = null;
    }
}