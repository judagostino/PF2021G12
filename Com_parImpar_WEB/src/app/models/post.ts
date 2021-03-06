import { Contact, State, TypeImpairment } from "../intrergaces";

export class Post {
    id?: number;
    dateEntered?: Date;
    title?: string;
    description?: string;
    text: string;
    state?: State;
    contactCreate?: Contact;
    contactAudit?: Contact;
    typeImpairment?: TypeImpairment[];
    imageUrl?: string;

    constructor() {
        this.id = 0;
        this.dateEntered = null;
        this.title = null;
        this.description = null;
        this.state = null;
        this.contactCreate = null;
        this.contactAudit = null;
        this.imageUrl = null;
        this.typeImpairment = null;
    }
}