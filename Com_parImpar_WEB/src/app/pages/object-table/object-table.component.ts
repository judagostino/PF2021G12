import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute } from '@angular/router';
import { AuditDialogComponent } from 'src/app/components/audit-dialog/audit-dialog.component';
import { Events } from 'src/app/models/events';
import { Post } from 'src/app/models/post';
import { EventsService, PostsService } from 'src/app/services';


@Component({
  selector: 'app-object-table',
  templateUrl: './object-table.component-copy.html',
  styleUrls: ['./object-table.component-copy.scss']
})
export class ObjectTableComponent implements OnInit {
  key = '';
  events: Events[] = [];
  posts: Post[] = [];
  public statusFilter = null;
  public dateFilter = null;
  public page = 0;

  constructor(
    private eventsService: EventsService,
    private postService: PostsService,
    public dialog: MatDialog,
    private activatedRoute: ActivatedRoute) {  }

  ngOnInit(): void {
    this.activatedRoute.paramMap.subscribe(params => {
      if (params.get('key') == 'event') {
        this.key = 'event';
        this.getGridEvent();
      } else if (params.get('key') == 'post') {
        this.key = 'post';
        this.getGridPost();
      }
    })
  }

  public openDialog(id: number): void {
    if (this.key == 'post') {
      this.postService.getById(id).subscribe( post => {
        this.showDialog({ post })
      });
    } else if (this.key == 'event') {
      this.eventsService.getById(id).subscribe(event => {
        this.showDialog({ event })
      })
    }
  } 

  private showDialog(data: any) {
    const dialogRef = this.dialog.open(
      AuditDialogComponent,
      {
        data,
        panelClass:'modalAuditoria'
      });

    dialogRef.afterClosed().subscribe((aux:string) => {
      if (aux != null && aux != undefined) {
        let result: {post?: Post, event?: Events, authorize?: boolean, reason?: string} = JSON.parse(aux);
        if (result.authorize != null) {
          if (result.authorize == true) {
            if (result.post != null) {
              this.btn_authorizePost(result.post.id)
            } else {
              this.btn_authorizeEvent(result.event.id)
            }
          } else {
            if (result.post != null) {
              this.btn_denyPost(result.post.id, result.reason)
            } else {
              this.btn_denyEvent(result.event.id, result.reason)
            }
          }
        }
      }
    });
  }

  private btn_authorizePost(id: number) : void {
    this.postService.authorize(id).subscribe( () => {
      this.getGridPost();
    });
  }

  private btn_denyPost(id: number, reason: string) : void {
    this.postService.deny(id, reason).subscribe( () => {
      this.getGridPost();
    });
  }

  private btn_authorizeEvent(id: number) : void {
    this.eventsService.authorize(id).subscribe( () => {
      this.getGridEvent();
    });
  }

  private btn_denyEvent(id: number, reason: string) : void {
    this.eventsService.deny(id, reason).subscribe( () => {
      this.getGridEvent();
    });
  }

  private getGridEvent(): void {
    this.eventsService.getAll(true).subscribe( resp => {
      this.events = [];
      this.events = resp;
    });
  }

  private getGridPost(): void {
    this.postService.getAll(true).subscribe( resp => {
      this.posts = [];
      this.posts = resp;
    });
  }

  public nextPage(){
    this.page += 5;
  }

  public prevPage(){
    if(this.page > 0)
    this.page -= 5;
  }
}
