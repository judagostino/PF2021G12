import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Events } from 'src/app/models/events';
import { ConfigService, EventsService } from 'src/app/services';

@Component({
  selector: 'app-events-info',
  templateUrl: './events-info.component.html',
  styleUrls: ['./events-info.component.scss']
})
export class EventsInfoComponent implements OnInit {
  eventElement: Events;

  constructor(
    private router: Router, 
    private activatedRoute: ActivatedRoute, 
    private configService: ConfigService,
    private eventsService: EventsService) { }

  ngOnInit(): void {
    window.scroll({top: 0, left: 0});
    this.activatedRoute.params.subscribe(params => {
      let id = params['id'];
      if (id != null && id != 0) {
        this.eventsService.getByIdMoreInfo(id).subscribe(resp => {
          this.eventElement = resp;
        })
      }
    });
  }

  public getImage(): string {
    if (this.eventElement != null && this.eventElement.imageUrl != null) {
      return this.eventElement.imageUrl.trim();
    } else {
      return this.configService.dafaultImage();
    }
  }

  public redirectToProfile(): void {
    this.router.navigateByUrl(`/profile/${this.eventElement.contactCreate.id}`)
  }
}
