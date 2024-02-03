import { formatDate } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Events } from 'src/app/models/events';
import { EventsService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-abm-events',
  templateUrl: './abm-events.component copy.html',
  styleUrls: ['./abm-events.component copy.scss']
})
export class ABMEventsComponent implements OnInit {
  form: FormGroup;
  events: Events[] = [];

  constructor(
    private formBuilder: FormBuilder, 
    private router: Router, 
    private eventsService: EventsService) { }

  ngOnInit(): void {
    this.initForm();
    this.form.reset(new Events());
    this.getGrid();
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
    })
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
            'Guardado',
            'Evento se elimino con exito!',
            'success'
          )
          this.form.reset(new Events())
        });
      }
    })
  }

  public btn_SelectEvent(event: Events) : void {
    this.eventsService.getById(event.id).subscribe( resp => {
      window.scroll({
        top: 0,
        left: 0,
        behavior: 'smooth'
      });
      this.form.reset(resp);
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

  private update(event: Events): void {
    this.eventsService.update(event.id,event).subscribe(resp => {
      this.form.reset(resp)
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
}
