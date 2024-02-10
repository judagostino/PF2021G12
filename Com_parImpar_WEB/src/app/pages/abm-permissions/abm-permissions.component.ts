import { Component, OnInit } from "@angular/core";
import { Contact } from "src/app/intrergaces/contact";
import { ConfigService, ContactService } from "src/app/services";

@Component({
    selector:'app-abm-permissions',
    templateUrl: './abm-permissions.component.html',
    styleUrls: ['./abm-permissions.component.scss']
})
export class ABMPermissionsComponent implements OnInit {
    contactSelected:Contact = null;
    contacts : Contact [] = []
    constructor(public contactService:ContactService,public configService:ConfigService){}

    ngOnInit(): void {
        if(this.configService?.isLogged && this.configService?.contact?.auditor){
            this.contactService.getAllContacts().subscribe(resp=>this.contacts=resp);
        }
    }

    public btn_SelectContact(contact:Contact):void {
        this.contactSelected = contact;
    }
}