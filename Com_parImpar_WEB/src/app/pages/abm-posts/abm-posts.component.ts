import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import moment from 'moment';
import { ReasonRejectDialogComponent } from 'src/app/components/reason-reject/reason-reject.component';
import { TypeImpairment } from 'src/app/interfaces';
import { Post } from 'src/app/models/post';
import { DenyReasonService, PostsService, TypeImpairmentService, UploadService } from 'src/app/services';
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
  typeImpairments: TypeImpairment[] = [];
  typeImpairmentsAux: boolean[] = [];
  reason: string= '';


  constructor(
    private formBuilder: FormBuilder, 
    private postService: PostsService,
    private uploadService: UploadService,
    private denyReasonService: DenyReasonService,
    private typeImpairmentService: TypeImpairmentService,
    public dialog:MatDialog) { }

  ngOnInit(): void {
    this.initForm();
    this.imageAux = null;
    this.typeImpairmentService.getAlll().subscribe(response => {
      for(let i = 0; i < response.length; i++) {
        this.typeImpairmentsAux.splice(0,0,false)
      }
      this.typeImpairments = response;
      this.populate(new Post());
    })
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
      const reader = new FileReader();

      this.uploadForm.get('file').setValue(file);

      reader.onload = (e: any) => {
        this.imageAux = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }

  public btn_SavePost(): void {
    let newPost = this.getPost();
    if (this.form.valid) {
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
    this.populate(new Post());
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
          this.getGrid();
          Swal.fire(
            'Guardado',
            'Publicación se elimino con exito!',
            'success'
          )
          this.populate(new Post())
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
      this.populate(resp)  
      if (resp.imageUrl) {
        this.imageAux = resp.imageUrl
      } else {
        this.imageAux = null;
      }

      if (resp?.state?.id == 3) {
        this.denyReasonService.getByKeyAndId('PostId',resp.id).subscribe((respose: {reason:string})=> {
          if (respose != null && respose.reason != null) {
            this.reason = respose.reason
          }
          else{
            this.reason = '';
          }
        });
      }
    },
    err => this.reason = '');
  }

  public objectComparisonFunction = function( option, value ) : boolean {
    return option.id === value.id;
  }
  
  private uploadImage(id: number) {
    if (this.uploadForm.get('file').value != null && this.uploadForm.get('file').value != '') {
      const formData = new FormData();
      formData.append('File', this.uploadForm.get('file').value);
      formData.append('Type', 'posts');
      formData.append('Id', id.toString());
  
      this.uploadService.upload(formData).subscribe((resp: {data:string}) => {
        if (resp.data != null) {
          this.imageAux = resp.data.trim()+'?c='+moment().unix();
        }
      },
      (error) => {
        console.error("Error en la carga de imágenes:", error);
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
      this.populate(resp)
      if (this.uploadForm.value != null) {
        this.uploadImage(resp.id)
      }
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
      this.populate(resp)
      if (this.uploadForm.value != null) {
        this.uploadImage(resp.id)
      }
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

  private getPost(): Post {
    let aux:TypeImpairment[] = [];
    
    for(let i = 0; i < this.typeImpairments.length; i++) {
      if (this.typeImpairmentsAux[i]) {
        aux.splice(0,0, this.typeImpairments[i]);
      }
    }

    this.form.controls.typeImpairment.setValue(aux);

    let post = this.form.value;
    
    return post;
  }

  private populate(post: Post): void {
    this.form.reset(post)

    if (post.typeImpairment?.length > 0) {
      post.typeImpairment.forEach(impementSelect => {
        this.typeImpairments.forEach((type,index) => {
          if(impementSelect?.id == type.id){
            this.typeImpairmentsAux[index] = true;
          }
        });
      });
    } else {
      this.typeImpairmentsAux.forEach(typeAux => typeAux = false);
    }
  }

  public reasonDescription() : void {
    this.dialog.open(ReasonRejectDialogComponent,{data:{reason:this.reason},panelClass:'modalReason'});
  }
}

