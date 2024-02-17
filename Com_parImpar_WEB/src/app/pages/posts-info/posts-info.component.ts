import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import moment from 'moment';
import { Post } from 'src/app/models/post';
import { ConfigService, PostsService } from 'src/app/services';

@Component({
  selector: 'app-posts-info',
  templateUrl: './posts-info.component.html',
  styleUrls: ['./posts-info.component.scss']
})
export class PostsInfoComponent implements OnInit {
  post: Post;

  constructor(
    private router: Router, 
    private activatedRoute: ActivatedRoute,
    private postsService: PostsService,
    private configService: ConfigService) { }

  ngOnInit(): void {
    window.scroll({top: 0, left: 0});
    this.activatedRoute.params.subscribe(params => {
      let id = params['id'];
      if (id != null && id != 0) {
        this.postsService.getByIdMoreInfo(id).subscribe(resp => {
          this.post = resp;
        })
      }
    });
  }

  public getImage(): string {
    if (this.post != null && this.post.imageUrl != null) {
      return this.post.imageUrl.trim()+'?c='+moment().unix();
    } else {
      return this.configService.dafaultImage();
    }
  }

  public redirectToProfile(): void {
    this.router.navigateByUrl(`/profile/${this.post.contactCreate.id}`)
  }
}
