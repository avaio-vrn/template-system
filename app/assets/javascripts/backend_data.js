var BackendData = {
  data_name: '',
  id: 0,
  template_id: 0,
  sending_data: {},
  set_data: function(data_name, id, template_id){
    this.data_name = data_name;
    this.id = id;
    this.template_id = template_id;
  },
  set_sending_data: function(params){
    this.sending_data = params;
  }
};

