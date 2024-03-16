import { Contact } from "./contact";
import { TypeImpairment } from "./type-impairment";


export interface SearchItem {
   id: number;
   key: string
   startDate?: Date;
   dateEntered?: Date;
   dateOrder?: Date;
   title: string;
   description: string;
   descriptionParagraphs?: string[];
   imageUrl: string;
   contactCreate: Contact;
   typeImpairment: TypeImpairment[];

}