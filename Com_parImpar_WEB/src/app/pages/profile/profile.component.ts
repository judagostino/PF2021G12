import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Contact } from 'src/app/intrergaces';
import { ConfigService, ContactService } from 'src/app/services';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {
  profile: Contact;

  constructor(
    private router: Router, 
    private contactService: ContactService,
    private activatedRoute: ActivatedRoute,

    private configService: ConfigService) { }

  ngOnInit(): void {
     window.scroll({top: 0, left: 0});
    this.activatedRoute.params.subscribe(params => {
      let id = params['id'];
      if (id != null && id != 0) {
        this.contactService.getByIdMoreInfo(id).subscribe(resp => {
          this.profile = resp;
        })
      }
    }); 

    


  }

  public getImage(): string {
    if (this.profile != null && this.profile.imageUrl != null) {
      return this.profile.imageUrl.trim();
    } else {
      return '/assets/image/user.png';
    }
  }
}
