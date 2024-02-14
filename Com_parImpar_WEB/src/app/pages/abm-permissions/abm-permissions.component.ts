import { Component, OnInit } from "@angular/core";
import { Contact } from "src/app/intrergaces/contact";
import { ConfigService, ContactService } from "src/app/services";
import {MatSnackBar} from '@angular/material/snack-bar';
import { MatDialog } from "@angular/material/dialog";
import { BlockUserDialogComponent } from "src/app/components/block-user/block-user.component";

@Component({
    selector:'app-abm-permissions',
    templateUrl: './abm-permissions.component.html',
    styleUrls: ['./abm-permissions.component.scss']
})
export class ABMPermissionsComponent implements OnInit {
    contactSelected:Contact = null;
    contacts : Contact [] = []
    constructor(
        public contactService:ContactService,
        public configService:ConfigService,
        public snackBar:MatSnackBar,
        public dialog:MatDialog){}

    ngOnInit(): void {
        if(this.configService?.isLogged && this.configService?.contact?.auditor){
            this.contactService.getAllContacts().subscribe(resp=>this.contacts=resp);
        }
    }

   public changeAuditor(contact:Contact):void{
    this.contactService.auditor(contact).subscribe(resp =>{
        if(contact.auditor){
            this.snackBar.open('Se ha marcado con éxito el usuario como auditor','Aceptar',{duration:3000,panelClass:'snackBar-end'})
        }
        else{
            this.snackBar.open('Se ha desmarcado con éxito el usuario como auditor','Aceptar',{duration:3000,panelClass:'snackBar-end'})
        }
        
    },
    err => {
        if(contact.auditor){
        this.snackBar.open('No se ha podido marcar el usuario como auditor','Aceptar',{duration:3000,panelClass:'snackBar-end'})
    }
    else{
        this.snackBar.open('Se ha desmarcado con éxito el usuario como auditor','Aceptar',{duration:3000,panelClass:'snackBar-end'})
        }
    })
   }

   public changeTrusted(contact:Contact):void{
    if(contact.trusted){
        this.contactService.trusted(contact).subscribe(resp =>{
            this.snackBar.open('Se ha marcado con éxito el usuario como de confianza','Aceptar',{duration:3000,panelClass:'snackBar-end'})

        },
        err => {
            this.snackBar.open('No se ha podido marcar el usuario como de confianza','Aceptar',{duration:3000,panelClass:'snackBar-end'})
        })
    }
    else {
        this.contactService.untrusted(contact).subscribe(resp =>{
            this.snackBar.open('Se ha deshabilitado con éxito el usuario como de confianza','Aceptar',{duration:3000,panelClass:'snackBar-end'})
        },
        err => {
            this.snackBar.open('No se ha podido desmarcar el usuario como de confianza','Aceptar',{duration:3000,panelClass:'snackBar-end'})
        }) 
    }
   } 
   
   public blockUser(contact:Contact):void {
    const dialogRef = this.dialog.open(
        BlockUserDialogComponent,
        {data:{contact},panelClass:'modalInscription'})
    dialogRef.afterClosed().subscribe((resp:boolean) => {
        if(resp == true){
            if(!contact.blocked){
                this.contactService.blocked(contact).subscribe(resp1 => {
                    contact.blocked = true;
                    this.snackBar.open('Se ha bloqueado con éxito el usuario seleccionado','Aceptar',{duration:3000,panelClass:'snackBar-end'})
                },
                err => {
                    this.snackBar.open('Hubo un problema al bloquear el usuario seleccionado','Aceptar',{duration:3000,panelClass:'snackBar-end'})
                })
            }
            else {
                this.contactService.unblocked(contact).subscribe(resp1 =>{
                   contact.blocked = false;
                    this.snackBar.open('Se ha desbloqueado con éxito el usuario seleccionado','Aceptar',{duration:3000,panelClass:'snackBar-end'})
                },
                err => {
                    this.snackBar.open('Hubo un problema al desbloquear el usuario seleccionado','Aceptar',{duration:3000,panelClass:'snackBar-end'})
                })  
            }
         
            
        }
    })
   }
}