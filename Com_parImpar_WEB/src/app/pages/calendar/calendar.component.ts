import { Component, OnInit } from '@angular/core';
import { Events } from 'src/app/models/events';
import { EventsService } from 'src/app/services';



@Component({
  selector: 'app-calendar',
  templateUrl: './calendar.component.html',
  styleUrls: ['./calendar.component.scss']
})
export class CalendarComponent implements OnInit {
  events: Events[] = []

  constructor(private eventsService: EventsService) { 

  }

  ngOnInit(): void {
    this.eventsService.getByDate(new Date('2021-10-08')).subscribe(response => {
      this.events = response;
    });
  }
}
