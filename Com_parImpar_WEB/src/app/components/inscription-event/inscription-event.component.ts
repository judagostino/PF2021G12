import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';


@Component({
  selector: 'app-inscription-event',
  templateUrl: './inscription-event.component.html',
  styleUrls: ['./inscription-event.component.scss']
})
export class InscriptionEventDialogComponent implements OnInit {
  showCorrectMessage = false;
  correctMessage = '';
  showErrorMessage = false;
  errorMessage = '';


  constructor(
    public dialogRef: MatDialogRef<InscriptionEventDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: {assist?:boolean,err?:any}) {}

  ngOnInit(): void {
    if(this.data != null){
      if(this.data.assist){
        if(this.data.err == null){
          this.correctMessage = 'Te has inscripto con éxito al evento';
          this.showCorrectMessage = true;
        }
        else {
          if(this.data?.err?.error?.code != null)
          {
            switch(this.data?.err?.error?.code){
              case 5916:{
                this.errorMessage = 'No se ha podido realizar la inscripción debido a que faltan menos de 48 hs para que comience el evento'
                break;
              }

              case 5015:{
                this.errorMessage = 'No se ha podido realizar la inscripción debido a que el usuario es inválido'
                break;
              }

              case 5917:{
                this.errorMessage = 'No se ha podido realizar la inscripción debido a que ya estas inscripto al evento'
                break;
              }

              case 5918:{
                this.errorMessage = 'No se ha podido realizar la inscripción debido a que el evento se encuentra en revisión'
                break;
              }
              
             default: {
              this.errorMessage = 'Ha ocurrido un error, intentelo de nuevo más tarde'
              break;
             }
            }
            this.showErrorMessage = true;
          }
          else {
            this.errorMessage = 'Ha ocurrido un error, intentelo de nuevo más tarde'
            this.showErrorMessage = true;

          }
        }
      }
      else {
         if(this.data.err == null){
          this.correctMessage = 'Has cancelado la inscripción al evento con éxito';
          this.showCorrectMessage = true;
        }
        else {
          if(this.data?.err?.error?.code != null)
          {
            switch(this.data?.err?.error?.code){
              case 5916:{
                this.errorMessage = 'No se ha podido anular la inscripción debido a que faltan menos de 48 hs para que comience el evento'
                break;
              }

              case 5015:{
                this.errorMessage = 'No se ha podido anular la inscripción debido a que el usuario es inválido'
                break;
              }

              case 5917:{
                this.errorMessage = 'No se ha podido anular la inscripción debido a que ya estas inscripto al evento'
                break;
              }

              case 5918:{
                this.errorMessage = 'No se ha podido anular la inscripción debido a que el evento se encuentra en revisión'
                break;
              }

              case 404:{
                this.errorMessage = 'No se ha encontrado la inscripción que desea anular'
                break;
              }


             default: {
              this.errorMessage = 'Ha ocurrido un error, intentelo de nuevo más tarde'
              break;
             }
            }
            this.showErrorMessage = true;
          }
          else {
            this.errorMessage = 'Ha ocurrido un error, intentelo de nuevo más tarde'
            this.showErrorMessage = true;
    
          }
        }
      }
    }
  }

  public closeModal():void {
    this.dialogRef.close();
  }
}
