import { Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { AnyARecord } from 'dns';
import moment from 'moment';
import { ReasonRejectDialogComponent } from 'src/app/components/reason-reject/reason-reject.component';
import { Events } from 'src/app/models/events';
import { DenyReasonService, EventsService, UploadService } from 'src/app/services';
import { ExportExcelService } from 'src/app/services/export-excel.service';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-abm-events',
  templateUrl: './abm-events.component copy.html',
  styleUrls: ['./abm-events.component copy.scss']
})
export class ABMEventsComponent implements OnInit {
  form: FormGroup;
  events: Events[] = [];
  uploadForm:FormGroup;
  imageAux = null;
  reason: string= '';
  @ViewChild('loadImage') loadImage:ElementRef;
  


  constructor(
    private formBuilder: FormBuilder, 
    private router: Router, 
    private uploadService: UploadService,
    private eventsService: EventsService,
    private denyReasonService: DenyReasonService,
    private exportExcelService: ExportExcelService,
    public dialog:MatDialog,) { }


  ngOnInit(): void {
    this.initForm();
    this.form.reset(new Events());
    this.getGrid();
    this.imageAux = null;
  }

  private initForm(): void {
    this.form = this.formBuilder.group({
      id: [''],
      dateEntered: [''],
      startDate: ['', [Validators.required]],
      endDate: [''],
      title: ['', [Validators.required]],
      description: ['', [Validators.required]],
      state: [''],
      contactCreate: [''],
      contactAudit: ['']
    });
    this.uploadForm = this.formBuilder.group({
      file: ['']
    });

  }

  public btn_SaveEvent(): void {
    if (this.form.valid) {
     let newEvent = this.form.value;
      if (newEvent.id === 0) {
        this.insert(newEvent);
      } else {
        this.update(newEvent);
      }
    } else {
      this.form.markAllAsTouched();
    }
  }

  public btn_NewEvent(): void {
    this.form.reset(new Events());
    this.imageAux = null;
  } 

  public btn_DeleteEvent(): void {
    Swal.fire({
      title:'¿Estás seguro?',
      text:'Una vez eliminado no podra recuperar este evento',
      icon:'warning',
      showCancelButton: true,
      confirmButtonColor: '#1995AD',
      cancelButtonColor: '#1995AD',
      confirmButtonText: 'Eliminar',
      cancelButtonText: 'Cancelar',
      customClass: {
        container: 'mi-modal-custom' // Clase personalizada para el contenedor del modal
      }
      
    
    }).then( resoult => {
      if (resoult.isConfirmed && resoult.value == true) {
        this.eventsService.delete(this.form.value.id).subscribe( () => {
          Swal.fire(
            'Eliminado',
            'Evento se elimino con exito!',
            'success'
          )
          this.getGrid();
          this.form.reset(new Events())
          this.imageAux = null;
        });
      }
    })
  }

  public onFileSelect(event) {
    if (event.target.files.length > 0) {
      const file = event.target.files[0];
      const reader = new FileReader();

      this.uploadForm.get('file').setValue(file);

      reader.onload = (e: any) => {
        this.imageAux = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }


  public btn_SelectEvent(event: Events) : void {
    this.eventsService.getById(event.id).subscribe( resp => {
      window.scroll({
        top: 0,
        left: 0,
        behavior: 'smooth'
      });
      this.form.reset(resp);
      if (resp.imageUrl) {
        this.imageAux = resp.imageUrl
      } else {
        this.imageAux = null;
      }

      if (resp?.state?.id == 3) {
        this.denyReasonService.getByKeyAndId('EventId',resp.id).subscribe((respose: {reason:string})=> {
          if (respose != null && respose.reason != null) {
            this.reason = respose.reason
          }
          else {
            this.reason = '';
          }
        },
        err => this.reason = '');
      }
    });
  }

  /**
   * Metodo encargado de buscar todos los datos con los filtros actualles y generar el archivo Excel correspondiente.
   * @param id Id del evento a buscar la lista.
   */
  public exportToExcel_Click(id: number): void {
    this.eventsService.getAllAssist(id).subscribe( (response) => {
        this.exportExcelService.exportToExcel(response);
      });
  }

  private getGrid(): void {
    this.eventsService.getAll().subscribe( resp => {
      this.events = [];
      this.events = resp;
    });
  }

  private insert(event: Events): void {
    this.eventsService.insert(event).subscribe(resp => {
      this.form.reset(resp)
      if (this.uploadForm.value != null) {
        this.uploadImage(resp.id)
      }
      this.getGrid();
      Swal.fire(
        'Guardado',
        'Evento guardado con exito!',
        'success'
      )
      this.router.navigateByUrl('/events');
    }, err => {
      Swal.fire(
        'Ops...',
        'Parece haber ocurrido un error, revise los datos e intentelo de nuevo mas tarde',
        'error'
      )
    });
  }

  private uploadImage(id: number) {
    if (this.uploadForm.get('file').value != null && this.uploadForm.get('file').value != '') {
      const formData = new FormData();
      formData.append('File', this.uploadForm.get('file').value);
      formData.append('Type', 'events');
      formData.append('Id', id.toString());
  
      this.uploadService.upload(formData).subscribe((resp: {data:string}) => {
        this.imageAux = resp.data.trim()+'?c='+ (moment().unix());
      });
    }
  }

  private update(event: Events): void {
    this.eventsService.update(event.id,event).subscribe(resp => {
      this.form.reset(resp)
      if (this.uploadForm.value != null) {
        this.uploadImage(resp.id)
      }
      this.getGrid();
      Swal.fire(
        'Guardado',
        'Evento guardado con exito!',
        'success'
      )
    }, err => {
      Swal.fire(
        'Ops...',
        'Parece haber ocurrido un error, revise los datos e intentelo de nuevo mas tarde',
        'error'
      )
    });
  }


  public reasonDescription() : void {
    this.dialog.open(ReasonRejectDialogComponent,{data:{reason:this.reason},panelClass:'modalReason'});
  }

  public selectImage($event:any): void {
    $event.stopPropagation();
    this.loadImage.nativeElement.click();
  }
}
