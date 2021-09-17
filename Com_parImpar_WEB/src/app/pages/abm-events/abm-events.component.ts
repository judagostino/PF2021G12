import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Events } from 'src/app/models/events';
import { EventsService } from 'src/app/services';

@Component({
  selector: 'app-abm-events',
  templateUrl: './abm-events.component.html',
  styleUrls: ['./abm-events.component.scss']
})
export class ABMEventsComponent implements OnInit {
  form: FormGroup
  events: Events[] = []

  constructor(private formBuilder: FormBuilder, private eventsService: EventsService) { }

  ngOnInit(): void {
    this.initForm();
    this.form.reset(new Events());
    this.getGrid();
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
      this.insert(newEvent);
    } else {
      this.update(newEvent);
    }
  }

  public btn_NewEvent(): void {
    this.form.reset(new Events());
  } 

  public btn_DeleteEvent(): void {
    this.eventsService.delete(this.form.value.id).subscribe( () => {
      this.form.reset(new Events())
    });
  }

  public btn_SelectEvent(event: Events) : void {
    this.eventsService.getById(event.id).subscribe( resp => {
      this.form.reset(resp)      
    });
  }

  public btn_authorizeEvent() : void {
    this.eventsService.authorize(this.form.value.id).subscribe( () => {
    });
  }

  public btn_denyEvent() : void {
    this.eventsService.deny(this.form.value.id).subscribe( () => {
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
    });
  }

  private update(event: Events): void {
    this.eventsService.update(event.id,event).subscribe(resp => {
      this.form.reset(resp)
      this.getGrid();
    });
  }
}
