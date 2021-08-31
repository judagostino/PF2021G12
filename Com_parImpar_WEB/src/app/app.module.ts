import { BrowserModule } from '@angular/platform-browser';
import { APP_INITIALIZER, NgModule } from '@angular/core';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http'

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HomeComponent } from './components/home/home.component';
import { HttpParImparInterceptor } from './interceptor/http-par-impar.interceptor';
import { ConfigService } from './services';

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule
  ],
  providers: [
    ConfigService,
    HttpParImparInterceptor,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: HttpParImparInterceptor,
      multi: true
    },
    {
      provide: APP_INITIALIZER,
      useFactory: appInitializerFactory,
      multi: true,
      deps: [ConfigService]
    },
],
  bootstrap: [AppComponent]
})
export class AppModule { }

export function appInitializerFactory(config: ConfigService) {
  return () => config.load();
}