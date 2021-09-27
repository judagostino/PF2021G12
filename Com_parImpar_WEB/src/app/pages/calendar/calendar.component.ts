import { Component, OnInit } from '@angular/core';
import { Events } from 'src/app/models/events';
import { EventsService } from 'src/app/services';
import * as moment from 'moment';


@Component({
  selector: 'app-calendar',
  templateUrl: './calendar.component.html',
  styleUrls: ['./calendar.component.scss']
})
export class CalendarComponent implements OnInit {
  events: Events[] = [];
  calendarDates: number[] = [];

  constructor(private eventsService: EventsService) { }

  ngOnInit(): void {
    this.createCalendar(new Date('2021-08-10'));
    this.initData(new Date('2021-08-10'));
  }

  public getEventsOfDay(day: number): number {
    if (day != 0) {
      return this.events.filter( event => (
        event.startDate != null 
        && moment(event.startDate).get('D') == day)
        ).length;
    }
    return 0;
  }

  private initData(date: Date): void {
    this.eventsService.getByDate(date).subscribe(response => {
      this.events = response;
    });
  }

  private createCalendar(date: Date): void {
    let limit = moment(date).daysInMonth();
    this.calendarDates = [];
    let initMounth = moment(date.getFullYear() + '-' +( date.getMonth() + 1) + '-1')
    let fistItems = 0;

    switch(initMounth.isoWeekday()) {
      // Lunes
      case 1: {
        fistItems = 0;
        break;
      }
      case 2: {
        fistItems = 1;
        break;
      }
      case 3: {
        fistItems = 2;
        break;
      }
      case 4: {
        fistItems = 3;
        break;
      }
      case 5: {
        fistItems = 4;
        break;
      }
      case 6: {
        fistItems = 5;
        break;
      }
      //Domingo
      default: {
        fistItems = 6;
        break;
      }
    }

    if (fistItems > 0) {
      for(let i = 1; i <= fistItems; i++) {
        this.calendarDates.push(0)
      }  
    }

    for(let i = 1; i <= limit; i++) {
      this.calendarDates.push(i)
    }
  }
}
