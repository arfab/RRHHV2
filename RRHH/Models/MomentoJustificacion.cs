namespace RRHH.Models
{
    public class MomentoJustificacion
    {

        public MomentoJustificacion()
        {
        }

        public MomentoJustificacion(int mom_id, string mom_descripcion)
        {
            id = mom_id;
            descripcion = mom_descripcion;
        }
       
        public int id { get; set; }

        public string descripcion { get; set; }

    }
}
