import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Events } from 'src/app/models/events';

@Component({
  selector: 'app-abm-events',
  templateUrl: './abm-events.component.html',
  styleUrls: ['./abm-events.component.scss']
})
export class ABMEventsComponent implements OnInit {
  form: FormGroup
  events: Events[] = [
    {
      id: 1, 
      title: 'Feria de libros para ciegos',
      description: 'muestra de eventos', 
      startDate: new Date("2020-12-1"),
      endDate: new Date("2020-12-1"),
      state: {
        id: 1,
        description: 'en espera'
      }
    },
    {
      id: 2, 
      title: 'Charla de integracion',
      description: 'muestra de eventos', 
      startDate: new Date("2020-12-1"),
      endDate: new Date("2020-12-1"),
      state: {
        id: 1,
        description: 'en espera'
      }
    },
    {
      id: 3, 
      title: 'encuensta de opinion',
      description: 'muestra de eventos', 
      startDate: new Date("2020-1-1"),
      endDate: new Date("2021-2-1"),
      state: {
        id: 2,
        description: 'Aprobar'
      },
      contactAudit: {
        userName: 'Test, Test'
      }
    },
    {
      id: 4, 
      title: 'Sueño dorado',
      description: 'muestra de eventos', 
      startDate: new Date("2020-12-1"),
      endDate: new Date("2020-12-1"),
      state: {
        id: 3,
        description: 'Rechazar'
      },
      contactAudit: {
        userName: 'Test, Test'
      }
    }
  ]

  lastId: number = 4;

  constructor(private formBuilder: FormBuilder) { }

  ngOnInit(): void {
    this.initForm();
    this.form.reset(new Events());
  }

  private initForm(): void {
    this.form = this.formBuilder.group({
      id: [null],
      dateEntered: [null],
      startDate: [null],
      endDate: [null],
      title: [null],
      description: [null],
      state: [null],
      contactCreate: [null],
      contactAudit: [null]
    })
  }

  public btn_SaveEvent(): void {
    let newEvent = this.form.value;

    if (newEvent.id === 0) {
      this.lastId = this.lastId + 1;
      newEvent.id = this.lastId;
      this.events.splice(this.events.length, 0, newEvent);
    } else {
      let index = this.events.indexOf(this.events.filter( eventAux=> eventAux.id === this.form.value.id).shift());
      this.events[index] = newEvent;
    }

    this.form.reset(new Events());
  }

  public btn_NewEvent(): void {
    this.form.reset(new Events());
  } 

  public btn_DeleteEvent(): void {
    let index = this.events.indexOf(this.events.filter( eventAux => eventAux.id === this.form.value.id).shift());
    this.events.splice(index, 1);
  }

  public btn_SelectEvent(event:Events) : void {
    this.form.reset(event)
  }

}
