namespace RRHH.Models
{
    public class Turno
    {
        public Turno()
        {
        }

        public Turno(int tur_id, string tur_descripcion, int tur_ubicacion_id, string tur_ubicacion)
        {
            id = tur_id;
            descripcion = tur_descripcion;
            ubicacion_id = tur_ubicacion_id;
            ubicacion = tur_ubicacion;

        }

        public int id { get; set; }

        public string descripcion { get; set; }

        public int ubicacion_id { get; set; }

        public string ubicacion { get; set; }

        public int? horas_diarias { get; set; }

        public int? horas_medio_franco { get; set; }

    }
}

