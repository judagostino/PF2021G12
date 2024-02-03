import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { TypeImpairment } from 'src/app/intrergaces';
import { Post } from 'src/app/models/post';
import { PostsService, TypeImpairmentService, UploadService } from 'src/app/services';
import Swal  from 'sweetalert2';

@Component({
  selector: 'app-abm-posts',
  templateUrl: './abm-posts.component copy.html',
  styleUrls: ['./abm-posts.component copy.scss']
})
export class ABMPostsComponent implements OnInit {
  form: FormGroup;
  posts: Post[] = [];
  uploadForm: FormGroup;  
  imageAux = null;
  types: TypeImpairment[] = [];


  constructor(
    private formBuilder: FormBuilder, 
    private postService: PostsService,
    private uploadService: UploadService,
    private typeImpairmentService: TypeImpairmentService) { }

  ngOnInit(): void {
    this.typeImpairmentService.getAlll().subscribe(response => {
      this.types = response;
    })
    this.initForm();  
    this.imageAux = null;
    this.form.reset(new Post());
    this.getGrid();
  }

  private initForm(): void {
    this.form = this.formBuilder.group({
      id: [null],
      dateEntered: [null],
      title: ['', [Validators.required]],
      description: ['', [Validators.required]],
      text: ['', [Validators.required]],
      state: [null],
      contactCreate: [null],
      contactAudit: [null],
      typeImpairment: ['', [Validators.required]]
    })
    this.uploadForm = this.formBuilder.group({
      file: ['']
    });
  }

  public onFileSelect(event) {
    if (event.target.files.length > 0) {
      const file = event.target.files[0];
      this.uploadForm.get('file').setValue(file);
    }
  }

  public btn_SavePost(): void {
    if (this.form.valid) {
      let newPost = this.form.value;
      console.log(newPost)
      if (newPost.id === 0) {
        this.insert(newPost);
      } else {
        this.update(newPost);
      }
    } else {
      this.form.markAllAsTouched();
    }
  }

  public btn_NewPost(): void {
    this.form.reset(new Post());
    this.imageAux = null;
  } 

  public btn_DeletePost(): void {
    Swal.fire({
      title:'¿Estás seguro?',
      text:'Una vez eliminado no podra recuperar esta publicación',
      icon:'warning',
      showCancelButton: true,
      confirmButtonColor: '#1995AD',
      cancelButtonColor: '#1995AD',
      confirmButtonText: 'Eliminar',
      cancelButtonText: 'Cancelar'
    }).then( resoult => {
      if (resoult.isConfirmed && resoult.value == true) {
        this.postService.delete(this.form.value.id).subscribe( () => {
          Swal.fire(
            'Guardado',
            'Publicación se elimino con exito!',
            'success'
          )
          this.form.reset(new Post())
          this.imageAux = null;
        });
      }
    })
  }

  public btn_SelectPost(post: Post) : void {
    this.postService.getById(post.id).subscribe( resp => {
      window.scroll({
        top: 0,
        left: 0,
        behavior: 'smooth'
      });
      this.form.reset(resp)  
      if (resp.imageUrl) {
        this.imageAux = resp.imageUrl
      }
    });
  }

  public objectComparisonFunction = function( option, value ) : boolean {
    return option.id === value.id;
  }
  
  private uploadImage(id: number) {
    if (this.uploadForm.get('file').value != null) {
      const formData = new FormData();
      formData.append('File', this.uploadForm.get('file').value);
      formData.append('Type', 'posts');
      formData.append('Id', id.toString());
  
      this.uploadService.upload(formData).subscribe((resp: string) => {
        //this.imageAux = resp.trim();
      });
    }
  }

  private getGrid(): void {
    this.postService.getAll().subscribe( resp => {
      this.posts = [];
      this.posts = resp;
    });
  }

  private insert(post: Post): void {
    this.postService.insert(post).subscribe(resp => {
      this.form.reset(resp)
      this.uploadImage(resp.id);
      this.getGrid();
      Swal.fire(
        'Guardado',
        'Publicación guardado con exito!',
        'success'
      )
    }, err => {
      Swal.fire(
        'Ops...',
        'Parece haber ocurrido un error, revise los datos e intentelo de nuevo mas tarde',
        'error'
      )
    });
  }

  private update(post: Post): void {
    this.postService.update(post.id,post).subscribe(resp => {
      this.form.reset(resp)
      this.uploadImage(resp.id);
      this.getGrid();
      Swal.fire(
        'Guardado',
        'Publicación guardado con exito!',
        'success'
      )
    }, err => {
      Swal.fire(
        'Ops...',
        'Parece haber ocurrido un error, revise los datos e intentelo de nuevo mas tarde',
        'error'
      )
    });
  }
}
