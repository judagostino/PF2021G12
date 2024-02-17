import { Component, Inject, OnInit, Type } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { TypeImpairment } from 'src/app/interfaces';
import { ConfigService, TypeImpairmentService } from 'src/app/services';
import { ContactTypeImpairmentService } from 'src/app/services/contact-type-impairments.service';


@Component({
  selector: 'app-disabilities-interest',
  templateUrl: './disabilities-interest.component.html',
  styleUrls: ['./disabilities-interest.component.scss']
})
export class DisabilitiesInterestDialogComponent implements OnInit {
  typeImpairments:TypeImpairment [] = [];
  typeImpairmentsAux:boolean [] = [];
  isFirst:boolean =  true;

  constructor(
    public dialogRef: MatDialogRef<DisabilitiesInterestDialogComponent>,
    private typeImpairmentService:TypeImpairmentService,
    private contactTypeImpairmentService:ContactTypeImpairmentService,
    public snackBar:MatSnackBar,
    public configService:ConfigService,

    ) {}

  ngOnInit(): void {
      this.typeImpairmentService.getAlll().subscribe(resp =>{
        for(let i = 0; i < resp.length; i++) {
          this.typeImpairmentsAux.splice(0,0,false)
        }
        this.typeImpairments = resp;
        this.getPreference();
      })
  }

  public closeModal():void {
    this.dialogRef.close();
  }

  private getPreference ():void {
    this.contactTypeImpairmentService.getAlll().subscribe(resp => {
      console.log(resp);
      if(resp.length > 0){
        this.isFirst = false;
        resp.forEach(element => {
          this.typeImpairments.forEach((type,index) => {
            if(element?.typeId == type.id){
              this.typeImpairmentsAux[index] = true;
            }
          });
        });
      }

      else{
        this.isFirst = true;
      }
    },
    err => {
      if(err?.status == 404){
        this.isFirst = true;
      }
    })
  }  
  
  public btn_Save() :void {
    let aux: number [] = [];
    this.typeImpairmentsAux.forEach((typeAux,index) => {
      if(typeAux){
        aux.push(this.typeImpairments[index].id)
      }
    });
    if(this.isFirst){
      this.contactTypeImpairmentService.insert(aux).subscribe(resp =>{
        if(aux.length == 0){
          this.isFirst = true;
        }
        else {
          this.isFirst = false;
        }
        this.snackBar.open('Se han actualizado tus preferencias con éxito','Aceptar',{duration:3000,panelClass:'snackBar-end'})
      },
      err => {
        this.snackBar.open('Hubo un problema al guardar sus preferencias, intentelo de nuevo más tarde','Aceptar',{duration:3000,panelClass:'snackBar-end'})
      })
    }

    else {
      this.contactTypeImpairmentService.update(aux,this.configService.contact.id).subscribe(resp =>{
        if(aux.length == 0){
          this.isFirst = true;
        }
        else {
          this.isFirst = false;
        }

        this.snackBar.open('Se han actualizado tus preferencias con éxito','Aceptar',{duration:3000,panelClass:'snackBar-end'})
      },
      err => {
        this.snackBar.open('Hubo un problema al guardar sus preferencias, intentelo de nuevo más tarde','Aceptar',{duration:3000,panelClass:'snackBar-end'})
      })

    }
  }

  }
