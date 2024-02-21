import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Events } from 'src/app/models/events';
import { ConfigService, EventsService } from 'src/app/services';
import moment from 'moment';
import { Router } from '@angular/router';
import { ContactEventsService } from 'src/app/services/contact-event.service';
import { Observable, of } from 'rxjs';
import { MatDialog } from '@angular/material/dialog';
import { InscriptionEventDialogComponent } from 'src/app/components/inscription-event/inscription-event.component';

@Component({
  selector: 'app-calendar',
  templateUrl: './calendar.component.html',
  styleUrls: ['./calendar.component.scss']
})


export class CalendarComponent implements OnInit {
  events: Events[] = [];
  
  calendarDates: number[] = [];
  month: String="";
  now = new Date();
  notResoults = false;

  constructor(
    public configService: ConfigService,
    private eventsService: EventsService,
    public router:Router,
    public changeDetectorRef: ChangeDetectorRef,
    public contactEventsService:ContactEventsService,
    public dialog:MatDialog) { }

  ngOnInit(): void {
    this.createCalendar(this.now);
    this.initData(this.now);
    this.month = moment(this.now).format('MMMM');
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
    this.events = [];
    this.notResoults = false;
    this.eventsService.getByDate(date).subscribe(response => {
      this.events = response;
      if (response.length == 0) {
        this.notResoults = true;
      }
    }, err => {
      this.notResoults = true;
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

  public btn_Subtract() : void {
    let aux = moment(this.now).subtract(1,'M');
    this.month = aux.format('MMMM');
    this.now = aux.toDate();
    this.createCalendar(this.now);
    this.initData(this.now);
  }

  public btn_Add() : void {
    let aux = moment(this.now).add(1,'M');
    this.month = aux.format('MMMM');
    this.now = aux.toDate();
    this.createCalendar(this.now);
    this.initData(this.now);
  }

  public showEvents(event:Events): void {
    this.router.navigateByUrl(`/events-info/${event.id}`)
  }


  public assist (event:Events, evt:any, index: number): void {
    evt.stopPropagation();
    if(!this.configService?.isLogged){
      return;
    }
    this.contactEventsService.postAssist(event.id).subscribe(resp => {
      this.events[index].assist = true;
      const dialogRef = this.dialog.open(
        InscriptionEventDialogComponent,
        {data:{assist:true},panelClass:'modalInscription'})

    },err =>{
        const dialogRef = this.dialog.open(
        InscriptionEventDialogComponent,
        {data:{assist:true,err},panelClass:'modalInscription'})
      });
  }

  public cancel_assist (event:Events, evt:any, index: number): void {
    evt.stopPropagation();
    if(!this.configService?.isLogged){
      return;
    }
    this.contactEventsService.cancelAssist(event.id).subscribe(resp => {
      this.events[index].assist = false;
      const dialogRef = this.dialog.open(
        InscriptionEventDialogComponent,
        {data:{assist:false},panelClass:'modalInscription'})

    },err =>{
        const dialogRef = this.dialog.open(
        InscriptionEventDialogComponent,
        {data:{assist:false,err},panelClass:'modalInscription'})
      });
  }

  public validateDate(event:Events):boolean {
    if(event?.startDate != null && !moment(event.startDate).isAfter(moment().add(48,'hours')))
    {
      return true;
    }
    return false;
  }
}