import { Injectable } from '@angular/core';
import { Events } from '../models/events';
import { Contact } from '../interfaces';
import * as ExcelJS from 'exceljs';
import * as fs from 'file-saver';
import moment from 'moment';


@Injectable({
  providedIn: 'root'
})
export class ExportExcelService {

  titleWorksheet = 'Asistencia';
  headerBgColor = '1995AD';
  headerFontColor = 'FFFFFF';
  constructor() { }


  /**
   * Metodo encargado de generar y organizar la info para exportar.
   * @param responseData respuesta de la peticion que armo la grilla.
   */
  public exportToExcel(responseData: Events): void {
    const workbook = new ExcelJS.Workbook();
    const worksheet = workbook.addWorksheet('Asistencia');
    this.initTitle(worksheet, responseData);
    this.setColumns(worksheet);
    this.setData(worksheet, responseData.contacts);
    this.createExcel(workbook, `Evento_${responseData.id}_${moment(responseData.startDate).format('DD/MM/YY-hh:mm')}_${moment(responseData.endDate).format('DD/MM/YY-hh:mm')}`);
  }


  /**
   * Metodo encargado de definir el estilo y ubicacion del titulo.
   * @param worksheet hoja de trabajo a editar.
   * @param title titulo a poner.
   */
  private initTitle(worksheet: ExcelJS.Worksheet, event: Events): void {
    // Add Row and formatting
    const titleRow = worksheet.getCell('B2');
    titleRow.value = event.title;
    titleRow.font = {
      name: 'Calibri',
      size: 16,
      bold: true
    };
    titleRow.alignment = {
      horizontal: 'left'
    };

    const startDate = worksheet.getCell('B4');
    startDate.value = `Fecha de inicio:`;
    startDate.font = {
        name: 'Calibri',
        size: 12,
    };
    startDate.alignment = {
        horizontal: 'left'
    };

    const valueStartDate = worksheet.getCell('C4');
    valueStartDate.value = `${moment(event.startDate).format('DD/MM/YY hh:mm')}`;
    valueStartDate.font = {
        name: 'Calibri',
        size: 12,
    };
    valueStartDate.alignment = {
        horizontal: 'left'
    };
    
    const endDate = worksheet.getCell('B5');
    endDate.value = `Fecha de fin:`;
    endDate.font = {
        name: 'Calibri',
        size: 12,
    };
    endDate.alignment = {
        horizontal: 'left'
    };

    const valueEndDate = worksheet.getCell('C5');
    valueEndDate.value = `${moment(event.endDate).format('DD/MM/YY hh:mm')}`;
    valueEndDate.font = {
        name: 'Calibri',
        size: 12,
    };
    valueEndDate.alignment = {
        horizontal: 'left'
    };
    
  }



  /**
   * Metodo encargado de definir el estilo, ancho y texto de cada una de las columnas.
   * @param worksheet hoja de trabajo a editar
   */
  private setColumns(worksheet: ExcelJS.Worksheet): void {
    worksheet.getColumn('B').width = 40;
    worksheet.getColumn('C').width = 28;
    // Adding Header Row

    const nameHeader = worksheet.getCell('B7');
    const assistHearder = worksheet.getCell('C7');
    
    nameHeader.value = 'Apellido,Nombre';
    nameHeader.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: this.headerBgColor },
        bgColor: { argb: this.headerBgColor },
    };
    nameHeader.font = {
        bold: true,
        color: { argb: this.headerFontColor },
        size: 12,
    };
    nameHeader.alignment = {
        vertical: 'middle',
        horizontal: 'center'
    };

    assistHearder.value = 'Asistencia';
    assistHearder.fill = {
        type: 'pattern',
        pattern: 'solid',
        fgColor: { argb: this.headerBgColor },
        bgColor: { argb: this.headerBgColor },
    };
    assistHearder.font = {
        bold: true,
        color: { argb: this.headerFontColor },
        size: 12,
    };
    assistHearder.alignment = {
        vertical: 'middle',
        horizontal: 'center'
    };
  }


  /**
   * Metodo encargado de definir cada uno de los renglones de la grilla,
   * tomando el tipo definido y haciendo la transformacion correspondiente.
   * @param worksheet hoja de trabajo a utilizar.
   * @param contacts respuesta del metodo que armo la grilla, puede incluir totalizadores o no.
   */
  private setData(worksheet: ExcelJS.Worksheet, contacts: Contact[]): void {
    let i = 8;
    contacts.forEach((contact: Contact, index: number) => {
      const nameValue = worksheet.getCell(`B${i + index}`);
      nameValue.value = contact.name;
    });
  }


  /**
   * Metodo encargado de generar y guardar el archivo final, con toda la informacion definida.
   * @param workbook libro de trabajo a guardar.
   * @param title titulo del libro de trabajo.
   */
  private createExcel(workbook: ExcelJS.Workbook, title: string): void {
     // Generate & Save Excel File
     workbook.xlsx.writeBuffer().then((data) => {
      const blob = new Blob([data], { type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' });
      fs.saveAs(blob, title + '.xlsx');
    });
  }
}
