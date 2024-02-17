import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import moment from 'moment';
import { Contact } from 'src/app/interfaces';
import { ContactService } from 'src/app/services';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component copy.html',
  styleUrls: ['./profile.component copy.scss']
})
export class ProfileComponent implements OnInit {
  profile: Contact;

  constructor(
    private contactService: ContactService,
    private activatedRoute: ActivatedRoute ) { }

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
      return this.profile.imageUrl.trim()+'?c='+moment().unix();
    } else {
      return '/assets/image/user.png';
    }
  }
}
